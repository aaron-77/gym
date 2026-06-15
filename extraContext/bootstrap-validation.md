# Bootstrap 5.3 Form Validation Strategy

## Overview

All frontend forms use Bootstrap 5.3 native form validation. This approach uses browser-native HTML5 validation (`:invalid` / `:valid`) combined with Bootstrap CSS feedback classes.

## Standard Form Structure

```html
<form id="formName" class="formulario needs-validation" action="..." method="post" novalidate>

    <div>
        <label for="inputField" class="form-label">Label</label>
        <input id="inputField" class="form-control" type="text" name="field" required>
        <div class="invalid-feedback">Campo obligatorio</div>
        <div class="valid-feedback"></div>
    </div>

    <button type="submit">Submit</button>
</form>
```

## Key Points

- `needs-validation` class on form identifies forms requiring validation
- `novalidate` attribute disables browser default validation UI
- Each field is wrapped in a simple `div` (no special classes needed)
- `div.invalid-feedback` contains the error message (shown only when invalid)
- `div.valid-feedback` is empty — only the border/icon changes on valid state
- Input uses standard HTML5 attributes: `required`, `min="1"`, `pattern`, etc.

## JavaScript Handler (Minimal)

```javascript
export async function handleFormSubmit(event) {
    event.preventDefault();
    const form = event.target;
    
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }
    
    // Proceed with fetch...
}
```

**What JS does NOT need to do:**
- Add/remove `is-invalid` or `is-valid` classes
- Manually show/hide feedback divs
- Handle input events to clear errors

**What Bootstrap handles automatically:**
- Shows `div.invalid-feedback` when input has `:invalid` and form has `was-validated`
- Hides `div.invalid-feedback` when input passes to `:valid`
- Shows `div.valid-feedback` when input is valid

## Server-Side Errors

When rendering a form with server-side validation errors (ModelState), include the error message in `div.invalid-feedback`:

```html
<div class="invalid-feedback">
    @(ViewData.ModelState["fieldName"]?.Errors.FirstOrDefault()?.ErrorMessage ?? "Campo obligatorio")
</div>
```

## CSS

No custom `.validation-error` rules needed. Remove any existing `.validation-error` CSS when migrating forms to this pattern. Bootstrap's `.invalid-feedback` / `.valid-feedback` handle all feedback styling.

## Migration from Old Pattern

Old pattern used:
- `<span class="validation-error">` 
- Custom CSS with `display: none` / `display: block`
- JS that manually toggled visibility

New pattern replaces these with:
- `div.invalid-feedback` / `div.valid-feedback`
- Bootstrap CSS classes
- Minimal JS (only `was-validated` on submit)