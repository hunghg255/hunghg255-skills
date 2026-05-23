---
name: antd-form-dependencies
description: "Ant Design Form dependency patterns — dependencies, shouldUpdate, Form.useWatch, cascading selects, custom form components. Use when working with antd Form.Item dependencies, cascading fields, province-district-ward selects, form field re-rendering, Form.useWatch hook, form.getFieldValue, form.setFieldValue. Triggers: 'antd form dependencies', 'cascading select antd', 'form shouldUpdate', 'Form.useWatch', 'antd form watch field', 'dependent form fields', 'reset dependent fields antd', 'custom component Form.Item value onChange', 'antd province district ward'. Actions: implement, fix, debug, refactor, review antd form dependencies."
---

# Antd Form Dependencies

IRON LAW: ALWAYS reset downstream dependent fields when a parent field changes. Stale data in dependent selects is a bug, not a feature.

## Workflow

Copy this checklist and check off items as you complete them:

```
Antd Form Dependencies Progress:

- [ ] Step 1: Analyze the dependency relationship ⚠️ REQUIRED
  - [ ] 1.1 Identify which fields depend on which
  - [ ] 1.2 Determine who owns the dependency logic (parent or child)
  - [ ] 1.3 Choose the correct pattern
- [ ] Step 2: Implement the chosen pattern ⚠️ REQUIRED
  - [ ] 2.1 (dependencies) Wrap with dependencies + noStyle + render props
  - [ ] 2.2 (shouldUpdate) Add comparison function + noStyle + render props
  - [ ] 2.3 (useWatch) Add hook inside child component
- [ ] Step 3: Add reset logic for downstream fields ⚠️ REQUIRED
- [ ] Step 4: Verify correctness
```

## Step 1: Analyze ⚠️ REQUIRED

Ask these questions before writing any code:

1. **Which fields depend on which?** Map the dependency chain (e.g., province → district → ward).
2. **Who owns the dependency logic?** Does the parent component control rendering, or is the child self-contained?
3. **Do you need custom comparison logic?** If simple "field A changed" → use `dependencies`. If "field A OR field B changed, but only when C is truthy" → use `shouldUpdate`.

Choose the pattern:

| Condition | Pattern |
|-----------|---------|
| Child component is self-contained, knows its own dependencies | `Form.useWatch` |
| Parent controls when child re-renders, simple field list | `dependencies` |
| Need custom re-render comparison logic | `shouldUpdate` |

→ Load `references/antd-form-patterns.md` for code examples of each pattern.

## Step 2: Implement ⚠️ REQUIRED

### Pattern A: `dependencies` (simple, declarative)

```tsx
<Form.Item dependencies={['province']} noStyle>
  {(props) => (
    <Form.Item name="district">
      <SelectDistrict province={props.getFieldValue('province')} />
    </Form.Item>
  )}
</Form.Item>
```

Key points:
- Outer `Form.Item` has `dependencies` + `noStyle` + render props function
- `props` is the form instance — use `props.getFieldValue()` to read values
- Inner `Form.Item` has `name` for normal value binding

### Pattern B: `shouldUpdate` (custom comparison)

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

### Pattern C: `Form.useWatch` (child-owned)

```tsx
const SelectDistrict = (props) => {
  const { value, onChange } = props;
  const province = Form.useWatch('province');

  const options = useMemo(() => {
    if (!province) return [];
    return districts.filter(d => d.parent_code === province);
  }, [province]);

  return <Select value={value} onChange={onChange} options={options} />;
};
```

No wrapper needed — the component watches its own dependency.

## Step 3: Add Reset Logic ⚠️ REQUIRED

When a parent field changes, ALL downstream fields MUST be reset. This is the Iron Law.

```tsx
const onProvinceChange = (value) => {
  form.setFieldValue('province', value);
  form.setFieldValue('district', undefined);  // Reset
  form.setFieldValue('ward', undefined);       // Reset
};
```

Ask: **When the parent value changes, which fields become invalid?** Reset ALL of them.

## Step 4: Verify

Check these before delivering:

1. **Cascading reset works?** Change province → district and ward clear.
2. **No stale data?** After reset, dependent selects show correct options (or empty).
3. **Custom component forwards `value` + `onChange`?** Without these, Form.Item can't track the value.
4. **No `shouldUpdate={true}` without reason?** True = re-render on every field change in the form.

## Anti-Patterns

- **Forgetting `noStyle` on wrapper Form.Item** → adds unwanted layout/margin
- **Not resetting downstream fields** → stale values persist after parent changes
- **Using `shouldUpdate={true}` carelessly** → re-renders on every keystroke anywhere in form
- **Not forwarding `value`/`onChange` in custom components** → form store goes out of sync
- **Using `Form.useWatch` outside `<Form>`** → hook needs Form context, will fail
- **Mutating form values directly** → always use `form.setFieldValue()`, never mutate
- **Creating a new array for `dependencies` on every render** → use stable reference or inline array

## Pre-Delivery Checklist

- [ ] Dependent fields reset when parent changes (Iron Law satisfied)
- [ ] Correct pattern chosen based on dependency ownership
- [ ] `noStyle` present on wrapper `Form.Item` (dependencies/shouldUpdate patterns)
- [ ] Custom components inside `Form.Item` accept and forward `value` + `onChange`
- [ ] No `shouldUpdate={true}` without explicit performance justification
- [ ] `Form.useWatch` only used inside components rendered within `<Form>`

**IMPORTANT**: Always use custom components with form.item because it's the best and most practical method; only use formwatch if that doesn't work. If you want to use Form.Watch, please ask me first so I can review it.
