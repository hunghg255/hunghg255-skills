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

## Custom Form Field Components — Complete Guide

When creating custom form field components for file uploads or complex inputs, follow this pattern:

### Custom Field Component Structure

```tsx
type CustomUploadFieldProps = {
  value?: string;
  onChange?: (value: string) => void;
  disabled?: boolean;
};

function CustomUploadField({ value, onChange, disabled }: CustomUploadFieldProps) {
  const [uploading, setUploading] = useState(false);
  // IMPORTANT: Local preview state must sync with form value
  const [preview, setPreview] = useState<string | undefined>(value);

  // CRITICAL: Sync local preview when form value changes (e.g., when editing)
  useEffect(() => {
    setPreview(value);
  }, [value]);

  const handleUpload = async (file: File) => {
    try {
      setUploading(true);
      const url = await uploadFile(file);
      setPreview(url);
      onChange?.(url); // Notify form of value change
      message.success('Upload successful');
    } catch {
      message.error('Upload failed');
    } finally {
      setUploading(false);
    }
    return false;
  };

  const handleRemove = () => {
    setPreview(undefined);
    onChange?.(''); // Notify form of empty value
  };

  // Render preview or upload area based on preview state
  if (preview) {
    return (
      <div>
        {/* Preview UI with remove button */}
        <Button onClick={handleRemove} disabled={disabled}>Remove</Button>
      </div>
    );
  }

  return (
    <Upload.Dragger beforeUpload={handleUpload} disabled={uploading || disabled}>
      {/* Upload UI */}
    </Upload.Dragger>
  );
}
```

### Using Custom Field in Form

```tsx
function MyForm() {
  const [form] = Form.useForm();

  const handleSubmit = async (values) => {
    // CRITICAL: Always use values from form, NOT from local state
    await api.submit({
      url: values.url,              // From form values
      thumbnail_url: values.thumbnail_url,  // From form values - NOT from state
    });
  };

  return (
    <Form form={form} onFinish={handleSubmit}>
      <Form.Item name="url" label="Video">
        <VideoUploadField />
      </Form.Item>

      <Form.Item name="thumbnail_url" label="Thumbnail">
        <ThumbnailUploadField />
      </Form.Item>
    </Form>
  );
}
```

### CRITICAL Rules for Custom Form Fields

1. **ALWAYS use form values in submit handler** - NEVER use local component state when submitting:
   ```tsx
   // ❌ WRONG - Using state
   thumbnail_url: thumbnailPreview,

   // ✅ CORRECT - Using form values
   thumbnail_url: values.thumbnail_url,
   ```

2. **ALWAYS sync local preview with form value via useEffect**:
   ```tsx
   useEffect(() => {
     setPreview(value);
   }, [value]);
   ```

3. **ALWAYS call onChange when value changes** (upload/remove):
   ```tsx
   onChange?.(url);    // When uploading
   onChange?.('');     // When removing
   ```

4. **ALWAYS reset form when modal closes** to prevent stale values:
   ```tsx
   useEffect(() => {
     if (!open) {
       form.resetFields();
     }
   }, [open, form]);
   ```

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

---

## ❌ CRITICAL PROVEN PITFALLS (THESE WILL BREAK YOUR CODE)

> ❌ **DO NOT EVER DO THESE THINGS. EVER.**
> All these have been proven to crash production code:

1.  **❌ NEVER call hooks inside render props function**
    ```tsx
    // ❌ FATAL ERROR: Invalid hook call / Rendered more hooks than previous render
    <Form.Item dependencies={['province']} noStyle>
      {(props) => {
        // ❌ DO NOT DO THIS. EVER.
        useEffect(() => {}, [])
        useRequest()
        useMemo()

        return <Form.Item name="ward" />
      }}
    </Form.Item>
    ```
    ✅ **ALWAYS move ALL hooks into top level component scope**

2.  **❌ NEVER call `form.setFieldValue` inside onChange handler**
    ```tsx
    // ❌ Creates infinite re-render loops
    <Select onChange={() => form.setFieldValue('ward', undefined)} />
    ```
    ✅ **ALWAYS put reset logic inside component using `Form.useWatch` + `useEffect`**

3.  **❌ NEVER use `form.watch()` with subscription at top level**
    ```tsx
    // ❌ Creates memory leaks and infinite re-renders
    useEffect(() => form.watch(() => {}), [form])
    ```
    ✅ **ALWAYS use `Form.useWatch` hook inside the component that needs the value**

4.  **❌ NEVER pass form instance as prop to child components**
    ```tsx
    // ❌ Tight coupling, anti-pattern
    <WardSelect form={form} />
    ```
    ✅ **ALWAYS use `Form.useWatch()` directly inside child component - it has access to form context automatically**

5.  **❌ NEVER have conditional hook calls**
    ```tsx
    // ❌ FATAL ERROR: Rendered more hooks than previous render
    if (province) {
      const { data } = useRequest(...)
    }
    ```
    ✅ **ALWAYS call all hooks unconditionally, handle condition inside the hook**

---

## ✅ FINAL CORRECT PATTERN (PROVEN IN PRODUCTION)

**This is the ONLY pattern that works 100% of the time, no bugs, no exceptions:**

```tsx
// ✅ 1. Dependent child component - fully self contained
function WardSelect({ value, onChange, disabled }) {
  // ✅ Always at TOP LEVEL of component
  const province = Form.useWatch('province');
  const { data: wards, loading } = useGetWards(province);

  // ✅ Reset logic belongs HERE - inside the component that depends on it
  useEffect(() => {
    onChange?.(undefined);
  }, [province, onChange]);

  return <Select value={value} onChange={onChange} options={wards} />
}

// ✅ 2. Usage in form - SUPER CLEAN
<Form.Item name="province">
  <ProvinceSelect />
</Form.Item>

<Form.Item name="ward">
  <WardSelect />
</Form.Item>
```

✅ **Zero wrapper** | ✅ **Zero dependencies props** | ✅ **Zero form instances passed** | ✅ **Zero bugs**

## Pre-Delivery Checklist

### For Dependencies (Cascading Fields)
- [ ] Dependent fields reset when parent changes (Iron Law satisfied)
- [ ] Correct pattern chosen based on dependency ownership
- [ ] `noStyle` present on wrapper `Form.Item` (dependencies/shouldUpdate patterns)
- [ ] No `shouldUpdate={true}` without explicit performance justification
- [ ] `Form.useWatch` only used inside components rendered within `<Form>`

### For Custom Upload Field Components
- [ ] Custom component accepts and forwards `value` + `onChange` props
- [ ] Local `preview` state syncs with `value` via `useEffect`
- [ ] `onChange(url)` called when upload succeeds
- [ ] `onChange('')` called when file is removed
- [ ] Submit handler uses `values.fieldName` NOT local component state
- [ ] Form `resetFields()` called when modal closes

**IMPORTANT**:
1. Always use custom components with Form.Item because it's the best and most practical method; only use Form.useWatch if that doesn't work.
2. When submitting forms with custom fields, ALWAYS use values from the form (e.g., `values.thumbnail_url`) NEVER use local component state (e.g., `thumbnailPreview`).
