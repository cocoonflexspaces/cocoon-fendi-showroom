# Fendi Showroom — venue proposal

**Event:** Top-client showroom presentation
**Dates:** September 6–13, 2026 (1 prep + 6 live + 1 strike)
**City:** New York · Manhattan
**Capacity:** ~40 staff, ≤20 clients on-site at any moment, by appointment

## Deck structure

A single self-contained `index.html` with six anonymized venue options across
two tiers — a lead shortlist (A, B, C) and a set of alternatives (D, E, F) —
plus an at-a-glance comparison, a teal services note, and a black next-steps
callout.

Venues are labelled by letter and described architecturally rather than by
name (per the standing client-facing rule).

| Slot     | Public label                                              | Status                                              | All-in           |
| -------- | --------------------------------------------------------- | --------------------------------------------------- | ---------------- |
| Venue A  | A landmarked Manhattan mansion · multi-floor              | Holds challengeable                                 | $355,000 (8d)    |
| Venue B  | A landmarked Upper East Side gallery house                | All Sept 6–13 dates confirmed available             | $676,000 (8d)    |
| Venue C  | A Beaux-Arts mansion on Fifth Avenue                      | Day rate confirmed · full-week availability TBC     | $312k (8d) / $39k (1-night) |
| Venue D  | An Astor-family townhouse · 5 stories + garden            | Availability not yet confirmed                      | $216,000 (8d)    |
| Venue E  | A 1919 Park Avenue mansion · 6 rooms + adjoining hall     | Building in maintenance through end Sept 2026       | On request       |
| Venue F  | A Gilded-Age pair of mansions · Fifth Avenue at 91st      | Weekend/holiday days only inside the window         | $30,000 (1-night)|

## Images

- `img/venue-a/` — 10 images, local
- `img/venue-b/` — 15 images, local
- `img/venue-c/` — 9 images, local
- `img/venue-d/` — loaded externally from the venue's website CDN
- `img/venue-e/` — loaded externally from the venue's website CDN
- `img/venue-f/` — 5 images local + 2 hero shots from the venue's website

Image bundle for the Discovery Portfolio Google Drive folder:
`cocoon-fendi-venue-images-2026-05-15.zip` in the project root (39 local
images across the four venues that host their photos locally).

## Deploy

```bash
cd cocoon-fendi-showroom
bash deploy.sh
```

Default repo name: `cocoon-fendi-showroom`. The script flips the repo public
when prompted (required for GitHub Pages on the free plan).
