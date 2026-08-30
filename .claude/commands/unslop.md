---
name: unslop
description: "Cut AI tells from a piece of writing — weekly docs, issue catalog entries, reference sheets, README and CLAUDE.md prose, drafted messages. Rewrites for plain human voice."
allowed-tools: Read Edit Bash
---

`$ARGUMENTS`

Edit text to remove AI patterns and put a human voice back in.

This runs only when you invoke it. It does not apply itself to every reply — reach for it when prose is going somewhere a person will read it: a weekly review, an issue catalog entry, a runbook, `README.md` or `CLAUDE.md`, or anything `/compose` is about to turn into an email.

A notebook has a particular reason to care. The whole point of yacho is that you read a document weeks later and trust what it says. Padded, voiceless prose is the failure mode — it survives the audit, looks maintained, and tells you nothing you can act on.

The argument is a file path, or the text to clean. If empty, ask what to work on. If the target is a file, read it, rewrite it, and show the diff before saving.

---

## Step 1 — Scan and rewrite

Work through the patterns below. Preserve meaning and match the intended tone. Do not "improve" the argument, only the prose.

---

## Step 2 — Add voice back

Removing patterns is half the job. Sterile, voiceless writing is just as obvious as slop.

- **Have opinions.** React to facts instead of neutrally listing pros and cons.
- **Vary rhythm.** Short sentences. Then longer ones that take their time. Mix it up.
- **Acknowledge complexity.** "Shipped, but the auth piece is going to bite us in January" beats "shipped".
- **Use "I" when it fits.** First person is not unprofessional, and in a personal notebook it is the natural register.
- **Let some mess in.** Perfect structure looks machine-made.
- **Be specific.** Not "this week was productive" but "three of the five P0 items closed; the other two are blocked on the vendor".

---

## Step 3 — Self-audit

Ask: "what makes this obviously AI generated?" Fix whatever is left.

---

## Step 4 — Show the result

For a file, show the diff and confirm. For inline text, return the rewrite and name the two or three patterns you cut.

---

## Patterns to detect and fix

Two of these are matters of the author's taste, not hard rules: **13 (em dashes)** and **26 (abstract metaphor nouns)**. Yacho's own docs use em dashes freely. Flag those two, do not silently enforce them, and follow the surrounding document's habits.

### Content

1. **Puffery.** "pivotal moment", "testament to", "evolving landscape", "setting the stage for", "indelible mark", "deeply rooted". Cut puffery, state what happened.
2. **Name-dropping.** Listing tools or people without context. Pick one, say what it did.
3. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete or expand with a real source.
4. **Promotional language.** "seamless", "vibrant", "breathtaking", "groundbreaking", "renowned", "stunning", "must-have". Use neutral descriptions.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete.
6. **Formulaic challenges.** "Despite challenges... continues to thrive." Replace with specific facts.

### Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Replace with plain words.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Just say "is" or "has".
9. **"Not just X, but Y."** State the point directly instead.
10. **Rule of three.** Forcing ideas into groups of three. Use the natural number.
11. **Synonym cycling.** Doc, artifact, entry, record all in one paragraph for the same thing. Pick one, repeat it.
12. **False ranges.** "from X to Y" where X and Y are not on a meaningful scale. List the topics directly.

### Style

13. **Em dash overuse.** *(Author's taste — flag, do not enforce.)* Heavy em-dash use reads as an AI tell to some readers. If the writing leans on them, offer periods or commas instead. Yacho's existing docs use em dashes as a house habit, so match the document you are editing rather than stripping them out.
14. **Colon overuse.** Colons are fine before a list or example. Not as mid-sentence connectors. "If you're new to this: instead of a todo app, you keep a notebook" adds nothing with the colon. Rewrite so the point stands on its own.
15. **Boldface overuse.** Do not bold every proper noun or acronym.
16. **Inline-header lists.** The tell is a bold label and colon that restates the line: "**Progress:** Progress was made...". Convert those to prose. A bold lead-in that ends in a period, names the item, and is followed by genuinely new detail ("**Tables over prose.** A reference sheet that needs a paragraph belongs in its own document.") is fine, not a tell.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove from headings and bullets. Status markers that carry meaning are not decoration — the `[ ]` `[~]` `[x]` `[-]` indicators and the callout icons in the templates stay.
19. **Curly quotes.** Replace with straight quotes.

### Communication artifacts

20. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove.
21. **Cutoff disclaimers.** "While specific details are limited..." Find the source or remove.
22. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.

### Filler

23. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". "It is important to note that" gets deleted.
24. **Excessive hedging.** "could potentially possibly be argued that it might" becomes "may".
25. **Generic conclusions.** "The future looks bright." State specific plans or facts.

### Jargon

26. **Abstract metaphor nouns.** *(Author's taste — flag, do not enforce.)* Substrate, wedge, vector, locus, vantage, nexus, primitive (as noun), harness (as metaphor), surface (as in "API surface"), bedrock, scaffolding (as metaphor), modality, paradigm, north star, flywheel. Each usually has a plainer concrete word: "substrate" becomes "base", "wedge in" becomes "add", "vector" becomes "way". Leave a term alone when it is the project's actual vocabulary — "north star" is a named yacho concept with a memory file behind it, so it stays.

### Plain speech

27. **Say what it does, not how it feels.** "the notebook keeps you grounded", "context you can trust" name a feeling. The fix names the mechanism or a number: "`/notebook-sync` flags any active doc whose `updated:` date is older than 14 days", "a wiki-link with no matching file gets reported with its line number". Ask what the sentence tells the reader to do or know, then write that. If you cannot restate it as a concrete instruction, fact, or number, cut it. One more check: if the sentence could appear unchanged in someone else's notebook, it says nothing about this one. Cut it.
28. **Shorten or split dense sentences.** If the reader has to backtrack to parse a sentence, break it in two or drop clauses. One idea per sentence.
29. **Active voice.** Prefer it. Catch "is/are/was/were + past participle" and name the actor: "the tracker is updated each session" becomes "update the tracker at the end of each session". Passive is fine only when the actor is unknown or genuinely does not matter.
30. **Cut adverbs, or use a stronger verb.** "moved quickly" becomes the number of items closed. "significantly improved" becomes the measured delta. An adverb propping up a weak verb means the verb is wrong.
31. **Prefer the plain word.** "utilize" becomes "use", "leverage" becomes "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if". The fancier synonym is rarely clearer.

---

## Where this fits

- `/compose` drafts a message, then this cleans it before it goes to Outlook or Teams.
- `/notebook-sync` finds a stale doc; this fixes the prose while you are already in the file.
- Issue catalog entries and runbooks are the highest-value targets. A vague symptom line is worthless six months later, and pattern 27 is the one that catches it.

**Reminder: this rewrites prose only. It never changes frontmatter, status indicators, wiki-links, or the substance of a claim.**
