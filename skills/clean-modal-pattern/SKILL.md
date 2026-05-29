---
name: clean-modal-pattern
description: "Universal self contained modal pattern - separate files, internal state, no parent pollution. Works for any modal library: Ant Design, Radix, MUI, Headless UI, Shadcn, custom. Trigger when creating modal, dialog, popup, drawer."
---

# 🛡️ IRON LAW - NON NEGOTIABLE
✅ **MODALS / DIALOGS / DRAWERS MUST LIVE IN THEIR OWN SEPARATE FILES. NEVER WRITE MODAL CODE DIRECTLY INSIDE A PARENT COMPONENT.**

✅ **Modal state (open/close) MUST BE SCOPED INSIDE THE MODAL COMPONENT ITSELF. NEVER PUT MODAL STATE IN PARENT COMPONENTS.**

✅ **You will be fired if you create useState in parent for controlling modal visibility.**

---

## Purpose
This is an **universal architecture pattern** that works with **ANY MODAL LIBRARY IN EXISTENCE**. It eliminates modal state pollution, removes boilerplate and makes modals fully self contained.

Applies to:
✅ Ant Design Modal / Drawer
✅ Radix UI Dialog
✅ MUI Modal / Dialog
✅ Headless UI Dialog
✅ Shadcn/ui Dialog
✅ Bootstrap Modal
✅ Custom built modals
✅ Any drawer, popup, overlay component

---

## ✅ Universal Workflow Checklist

When you need to create or modify ANY modal/dialog/drawer:

- [ ] ⛔ BLOCKING: Create a NEW separate file for this modal. Name it `ModalXxx.tsx` / `DialogXxx.tsx` / `DrawerXxx.tsx`
- [ ] ⚠️ REQUIRED: Define all modal state **INSIDE THIS FILE ONLY**
  - `const [open, setOpen] = useState(false)` lives here
  - onOpen / onClose functions live here
  - No useState in parent. Ever.
- [ ] Expose trigger element via `children` prop
- [ ] Render BOTH trigger element AND modal component together in the same return
- [ ] Export only the modal component. Do not export state or control functions.
- [ ] In parent component: Import modal and wrap **ONLY THE TRIGGER ELEMENT** inside it
- [ ] Optional: Add forwardRef + useImperativeHandle **ONLY IF** external control is explicitly required

---

## 🔄 MIGRATION EXISTING MODALS TO THIS PATTERN

✅ USE THIS WHEN:
- You have existing modals written the wrong way
- User asks to "fix", "cleanup", "refactor", or "migrate" modals
- You find anti-patterns in existing code

### Migration Workflow Checklist:

- [ ] ⚠️ REQUIRED: First verify the old modal still works correctly before touching anything
- [ ] Create a NEW separate file `ModalXxx.tsx` (do NOT modify the old code yet)
- [ ] Copy ONLY the modal content and logic into the new file using the correct pattern
- [ ] Keep 100% identical functionality, props, callbacks, behavior. DO NOT change anything else.
- [ ] Replace the usage in parent one step at a time:
  1. Remove `const [open, setOpen] = useState(false)` from parent
  2. Remove all `onClick={() => setOpen(true)}` handlers on trigger
  3. Remove the old `<Modal />` JSX from parent render
  4. Import new modal and wrap ONLY the trigger button
  5. Test. Verify everything works EXACTLY same as before.
- [ ] ⛔ BLOCKING: Delete ALL old modal related code from parent. Do not leave commented out code.
- [ ] If there were multiple modals in the same parent, migrate them **ONE BY ONE**. Never migrate 2+ modals at the same time.

### What to do when the migrate skill doesn't work:
> If the general migrate skill fails or produces bad results:
> 1. Stop. Do not keep trying random approaches.
> 2. Use this exact migration checklist above
> 3. Migrate manually one modal at a time following the pattern
> 4. This pattern is simple enough that manual migration is always faster and more reliable than automated tools.

---

## 📐 Universal Pattern Structure

```tsx
import React, { useState } from 'react';
// IMPORT ANY MODAL COMPONENT FROM ANY LIBRARY HERE
import { Modal } from 'antd';
// import { Dialog } from '@radix-ui/react-dialog';
// import { Dialog } from '@mui/material';
// import { Dialog } from '@/components/ui/dialog';

interface IPropsModal {
  children: React.ReactNode;
  // Add any other props you need here
}

const ModalXxx = ({ children, ...rest }: IPropsModal) => {
  // ✅ THIS IS THE ONLY PLACE MODAL STATE EXISTS
  const [open, setOpen] = useState(false);

  const onOpen = () => setOpen(true);
  const onClose = () => setOpen(false);

  return (
    <>
      {/* ✅ Trigger element passed via children */}
      <span onClick={onOpen}>{children}</span>

      {/* INSERT ANY MODAL COMPONENT HERE FROM ANY LIBRARY */}
      <Modal
        open={open}
        onClose={onClose}
        {...rest}
      >
        {/* Modal content goes here */}
        Modal Content
      </Modal>
    </>
  );
};

export default ModalXxx;
```

### Parent Usage - Same for every library
```tsx
import ModalXxx from './ModalXxx';

const Parent = () => {
  return (
    <div>
      {/* ✅ WRAP ONLY THE TRIGGER BUTTON. NO STATE HERE. NO BOILERPLATE. */}
      <ModalXxx>
        <button type="button">Open Modal</button>
      </ModalXxx>
    </div>
  );
};

export default Parent;
```

---

## ❌ Anti-Patterns - NEVER DO THESE FOR ANY LIBRARY

1. ❌ **DO NOT** declare modal useState in parent component
2. ❌ **DO NOT** pass `open` and `setOpen` as props from parent
3. ❌ **DO NOT** write Modal JSX directly inside parent component render
4. ❌ **DO NOT** export open/close functions from modal
5. ❌ **DO NOT** use context / redux / global state for modal visibility
6. ❌ **DO NOT** have 3+ modals in the same file
7. ❌ **DO NOT** create custom hooks for controlling modals

---

## 🧪 Verification Checklist before delivery

- [ ] Modal is in its own separate `.tsx` file
- [ ] useState for open is declared inside modal component
- [ ] Parent component has **zero** state related to this modal
- [ ] Parent only imports and wraps the trigger button
- [ ] No props for open / onClose are exposed
- [ ] Modal can be moved anywhere in the app without changing parent code
- [ ] Multiple instances of same modal work independently

---

## ⚡ Advanced: External Control (Only if required)

Only add this if the parent **really** needs to open/close the modal externally. 90% of modals do not need this.

```tsx
import React, { useState, useImperativeHandle, forwardRef } from 'react';

export interface ModalXxxRef {
  open: () => void;
  close: () => void;
}

const ModalXxx = forwardRef<ModalXxxRef, IPropsModal>(({ children }, ref) => {
  const [open, setOpen] = useState(false);

  useImperativeHandle(ref, () => ({
    open: () => setOpen(true),
    close: () => setOpen(false),
  }));

  // rest same as before
});
```

---

## 💡 Why this pattern is superior to every other pattern:

1. ✅ Zero state pollution in parent components
2. ✅ Modal is fully reusable anywhere in application
3. ✅ Delete modal component = 100% clean removal, no leftover state
4. ✅ Multiple instances work perfectly out of the box
5. ✅ Parent does not need to know anything about modal internals
6. ✅ Zero boilerplate setup in parent
7. ✅ Works exactly same with every modal library ever created
