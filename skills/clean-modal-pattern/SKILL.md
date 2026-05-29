---
name: clean-modal-pattern
description: "Universal self contained modal pattern - separate files, internal state, no parent pollution. Works for any modal library: Ant Design, Radix, MUI, Headless UI, Shadcn, custom. Trigger when creating modal, dialog, popup, drawer."
trigger:
  - when you see any modal with useState in parent
  - when you see open/onCancel props passed to modal
  - when you see <Modal> JSX written directly inside parent render
  - when user says: modal, dialog, drawer, popup, fix modal, clean modal, migrate modal
auto: true
---

# 🛡️ IRON LAW - NON NEGOTIABLE
> ✅ These are not suggestions. These are rules. Failure is not allowed.

1. ✅ **MODALS / DIALOGS / DRAWERS MUST LIVE IN THEIR OWN SEPARATE FILES. NEVER WRITE MODAL CODE DIRECTLY INSIDE A PARENT COMPONENT.**
2. ✅ **Modal state (open/close) MUST BE SCOPED INSIDE THE MODAL COMPONENT ITSELF. NEVER PUT MODAL STATE IN PARENT COMPONENTS.**
3. ✅ **You will be fired if you create useState in parent for controlling modal visibility.**
4. ✅ **IF YOU SEE A MODAL DONE WRONG - YOU MUST FIX IT. YOU DO NOT NEED PERMISSION. THIS IS NON NEGOTIABLE.**

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

- [ ] ⛔ BLOCKING: Verify the old modal works correctly before touching anything. Do not refactor broken code.
- [ ] Create a NEW separate file `ModalXxx.tsx` (DO NOT modify the old code yet)
- [ ] Copy ONLY the modal content and logic into the new file using the correct pattern
- [ ] KEEP 100% IDENTICAL functionality, props, callbacks, behaviour. **DO NOT CHANGE ANYTHING ELSE.** No cleaning. No renaming. No improvements.
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

  return (
    <>
      {/* ✅ Trigger element passed via children */}
      <span onClick={() => setOpen(true)}>{children}</span>

      {/* INSERT ANY MODAL COMPONENT HERE FROM ANY LIBRARY, The open, onClose props depend on the library */}
      <Modal
        open={open}
        onClose={() => setOpen(false)}
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

## ⚠️ COMMON MIGRATION MISTAKES - 90% OF THE TIME AI WILL FAIL HERE

> ✅ These are the exact mistakes every AI makes. YOU ARE NOT ALLOWED TO MAKE THESE.

1.  ❌ **#1 MOST COMMON FAILURE**: When migrating an existing modal that already uses `onCancel` **DO NOT CHANGE THE LIBRARY PROP NAME**.
    - ✅ Leave `onCancel` exactly as it is on the library `<Modal>` component
    - ❌ **NEVER EVER** change `<Modal onCancel={...}>` to `<Modal onClose={...}>`. Ant Design does NOT have an `onClose` prop. This is the single most common bug.
    - The open, onClose props depend on the library you use. Follow the library docs for the correct prop names. Do not rename them.

2.  ❌ Do NOT refactor, rename variables, change logic, improve, or clean up anything during migration.
    - Migration = move code without changing behaviour.
    - Refactor and clean up ONLY after migration is 100% complete and verified working.

3.  ❌ Do NOT delete old code from parent until you have wrapped the trigger button and verified the modal opens and closes correctly.

4.  ❌ Never migrate more than ONE modal at the same time. Finish, test, typecheck one modal completely before touching the next one.

5.  ✅ **EXACT MIGRATION ORDER YOU MUST FOLLOW**:
    1. Add `children` prop + `const [open, setOpen] = useState(false)` inside modal
    2. Add the trigger wrapper `<span onClick={() => setOpen(true)}>{children}</span>` at the start of return
    3. Remove `open` and `onCancel` from the modal props interface
    4. The open, onClose props depend on the library you use. Follow the library docs for the correct prop names. Do not rename them.
    5. **ONLY THEN** go to parent, remove old state, wrap trigger button

---

## 💡 Why this pattern is superior to every other pattern:

1. ✅ Zero state pollution in parent components
2. ✅ Modal is fully reusable anywhere in application
3. ✅ Delete modal component = 100% clean removal, no leftover state
4. ✅ Multiple instances work perfectly out of the box
5. ✅ Parent does not need to know anything about modal internals
6. ✅ Zero boilerplate setup in parent
7. ✅ Works exactly same with every modal library ever created
