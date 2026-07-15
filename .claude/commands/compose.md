---
name: compose
description: "Draft a message and output it as a clean HTML file in scratch/ for copy-pasting into Outlook or Teams. Preserves bold, bullets, links, and numbered lists without dark-theme styling artifacts."
allowed-tools: Read Write
---

`$ARGUMENTS`

Draft a message based on the user's instructions and write it as a clean HTML file to `scratch/compose-output.html`.

---

## Step 1: Draft the Message

Use `$ARGUMENTS` to understand what to write. Common forms:
- A plain description: `/compose meeting invite for X about Y`
- A topic + audience: `/compose follow-up email to Stevin about Japan trip outcomes`
- Raw content to format: `/compose [paste unformatted text here]`

If the arguments describe what to write, draft the message using relevant context from the vault (recent weekly doc, tracker, memory). If the arguments contain raw content, format and clean it up without rewriting substance.

Keep the tone professional but direct. Match the register to the audience — internal teammate vs. executive vs. customer.

---

## Step 2: Write the HTML File

Write the message to `scratch/compose-output.html` using this template:

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
  body { font-family: Calibri, Arial, sans-serif; font-size: 11pt; color: #000000; max-width: 640px; padding: 24px; line-height: 1.5; }
  p { margin: 0 0 10px 0; }
  ul, ol { margin: 6px 0 12px 0; padding-left: 22px; }
  li { margin-bottom: 6px; }
  b, strong { font-weight: bold; }
  a { color: #0563C1; text-decoration: underline; }
  h3 { font-size: 11pt; font-weight: bold; margin: 14px 0 4px 0; }
  .label { font-weight: bold; }
</style>
</head>
<body>
[message content here]
</body>
</html>
```

Use semantic HTML only — `<p>`, `<ul>`, `<ol>`, `<li>`, `<b>`, `<a>`, `<br>`. No `<div>` with background colors, no inline color styles, no `<table>` layouts. This keeps the paste clean in both Outlook and Teams.

---

## Step 3: Tell the User

After writing the file, say:

> **Done.** Open `scratch/compose-output.html` in Chrome or Safari → Select All (⌘A) → Copy (⌘C) → Paste into Outlook or Teams.
>
> [Show the drafted message text here so they can review without opening the file]
