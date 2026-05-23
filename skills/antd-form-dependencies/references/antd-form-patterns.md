# Ant Design Form Dependency Patterns

Based on: https://blog.hunghg.me/blogs/handle-form-antd-part-1

## Table of Contents

1. [Form.Item Value Binding](#1-formitem-value-binding)
2. [Custom Components with Form.Item](#2-custom-components-with-formitem)
3. [Dependencies Pattern](#3-dependencies-pattern)
4. [shouldUpdate Pattern](#4-shouldupdate-pattern)
5. [Form.useWatch Pattern](#5-formusewatch-pattern)
6. [Decision Matrix](#6-decision-matrix)

---

## 1. Form.Item Value Binding

`Form.Item` with `name` automatically injects `value` and `onChange` into its direct child:

```tsx
<Form.Item name="username">
  <Input />  {/* Automatically receives value & onChange */}
</Form.Item>
```

On submit: `{ username: "entered_value" }`

## 2. Custom Components with Form.Item

When extracting to a custom component, `value` and `onChange` are passed as props — MUST forward them manually:

```tsx
const CustomInput = (props) => {
  const { value, onChange } = props; // id, value, onChange from Form.Item
  return (
    <Row>
      <label>Username</label>
      <Input value={value} onChange={onChange} />
    </Row>
  );
};

// Usage
<Form.Item name="username">
  <CustomInput />
</Form.Item>
```

**Key rule**: Any component inside `Form.Item` with `name` MUST accept `value` and `onChange` props to sync with the form store.


## 3. Dependencies Pattern

Use `dependencies` when a Form.Item needs to re-render when another field changes. Classic case: cascading selects (Province → District → Ward).

```tsx
{/* Province select — independent */}
<Form.Item name="province">
  <SelectProvince />
</Form.Item>

{/* District select — depends on province */}
<Form.Item dependencies={['province']} noStyle>
  {(props) => (
    <Form.Item name="district">
      <SelectDistrict province={props.getFieldValue('province')} />
    </Form.Item>
  )}
</Form.Item>

{/* Ward select — depends on district */}
<Form.Item dependencies={['district']} noStyle>
  {(props) => (
    <Form.Item name="ward">
      <SelectWard district={props.getFieldValue('district')} />
    </Form.Item>
  )}
</Form.Item>
```

**How it works**:
- `dependencies={['province']}` → re-renders when `province` changes
- `noStyle` → wrapper Form.Item renders no UI, only passes `props` (form instance) to children
- `props.getFieldValue('province')` → reads current value from form store
- The inner `Form.Item name="district"` handles value binding normally

**When province changes, you should reset district and ward**:

```tsx
const onProvinceChange = (value) => {
  form.setFieldValue('district', undefined);
  form.setFieldValue('ward', undefined);
};
```

## 4. shouldUpdate Pattern

`shouldUpdate` gives fine-grained control over when to re-render. Takes a function `(prevValues, nextValues) => boolean`:

```tsx
<Form.Item
  shouldUpdate={(prev, next) => prev.province !== next.province}
  noStyle
>
  {(props) => (
    <Form.Item name="district">
      <SelectDistrict province={props.getFieldValue('province')} />
    </Form.Item>
  )}
</Form.Item>
```

**Performance warning**: `shouldUpdate={true}` re-renders on ANY field change in the entire form. Always use a comparison function unless debugging.

**dependencies vs shouldUpdate**:
- `dependencies={['province']}` = shorthand for `shouldUpdate` that only checks those specific fields
- `shouldUpdate` = explicit control over comparison logic
- Prefer `dependencies` for simple cases; use `shouldUpdate` when you need custom comparison logic

## 5. Form.useWatch Pattern

`Form.useWatch` is a hook that subscribes to field value changes from INSIDE a component. Best when the dependent logic lives within the child component itself.

```tsx
const SelectDistrict = (props) => {
  const { value, onChange } = props; // from Form.Item
  const province = Form.useWatch('province'); // listens to province field

  const districtsData = React.useMemo(() => {
    if (!province) return [];
    return districts.filter((d) => d.parent_code === province);
  }, [province]);

  return (
    <Select
      value={value}
      onChange={onChange}
      options={districtsData}
    />
  );
};

// Usage — no dependencies wrapper needed
<Form.Item name="province">
  <SelectProvince />
</Form.Item>
<Form.Item name="district">
  <SelectDistrict />  {/* Self-contained: watches province internally */}
</Form.Item>
```

**Advantage**: The child component is self-contained — it watches its own dependencies without parent wrappers.

**Constraint**: Must be used inside a `<Form>` component (it reads from Form context).

## 6. Decision Matrix

| Scenario | Pattern | Why |
|----------|---------|-----|
| Child component owns the dependency logic | `Form.useWatch` | Self-contained, no wrapper needed |
| Parent controls the dependency rendering | `dependencies` | Simple, declarative |
| Need custom re-render comparison | `shouldUpdate` | Full control over when to re-render |
| Need to READ a value without re-render | `form.getFieldValue` | Inside render props function |
| Need to WRITE a value programmatically | `form.setFieldValue` | Reset cascading fields, set defaults |
| Custom component inside Form.Item | Forward `value` + `onChange` | Required for form store sync |

## Common Pitfalls

1. **Forgetting `noStyle` on wrapper Form.Item**: Without `noStyle`, the wrapper adds extra layout/margin.
2. **Not resetting dependent fields**: When province changes, district and ward should be cleared — otherwise stale data persists.
3. **Using `shouldUpdate={true}` carelessly**: Causes re-render on every keystroke in any field.
4. **Not forwarding `value`/`onChange` in custom components**: Form.Item can't track the value without these props.
5. **Using `Form.useWatch` outside `<Form>`**: Hook relies on Form context — will throw or return undefined.
