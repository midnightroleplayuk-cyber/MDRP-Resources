# NDM_Surgery

Surgery add-on for `osp_ambulance`. Reads and writes OSP's `BodyDamage` data directly, so anything
done here shows up in the OSP medical menu (and the NDM_MRI report).

## Requirements
- ox_lib, ox_target, osp_ambulance, qbx_core
- ox_inventory (only if you set items on procedures)

## Setup
1. Stand on the operating table where the patient should lie, face the right way and run `/surgerypos`.
2. Paste the copied `vector4` into `Config.Tables` in `config.lua` (the default one is a placeholder).
3. `ensure NDM_Surgery` after `osp_ambulance`.

## Flow
1. **Place patient on operating table** (medic, ox_target on the table). Downed / dead patients work too
   and use the table lying pose instead of OSP's downed pose.
2. **Perform surgery** opens the menu: patient vitals + every body part with its findings.
3. **General anaesthesia** — needed first for conscious patients (screen goes black until woken).
   Downed patients skip this.
4. **Bullet removal** — removes one OSP bullet wound per go (low / medium / high velocity).
5. **Internal damage repair** — removes crush / puncture / avulsion wounds, and bleeding on the
   head / torso that has no visible wound.
6. **Shrapnel removal** — explosion / shotgun wounds (`velocitywound`). Each wound has 2-4 fragments
   (random) and one comes out per successful go.
7. **Fracture repair (ORIF)** — fixes an X-rayed / MRI'd or splinted fracture outright (no cast or
   heal timer). Splints are taken off. Fractures already in a cast can't be operated on.
8. **Wound debridement** — cleans and closes cuts, lacerations and abrasions on a body part in one go
   (no general anaesthesia needed, no stitching after).
9. **Stitching** — closes the incision. If the area has no wounds left, bleeding and damage reset.
10. **Major surgery** — hands-on mini-games: heart / kidney / lung transplant (fix internal damage on
    the torso) and arm / leg reconstruction (fix fractures on both limbs). Needs anaesthesia like the
    other incisions. Stitch the area afterwards.
11. **Wake patient**, then **Remove patient from operating table**.

### Major surgery
Mouse moves the hand, left click lowers it, right click rotates, space grabs tools / organs,
Backspace / Esc cancels. Keep an eye on the blood counter: every open bleed drains it, close them with
the syringe. Running out of blood fails the surgery (complication, or death with
`Config.MajorSurgery.killOnFail = true`).

**Surgical training** on the table lets medics practise every mini-game on a dummy.

If the organs / dummy don't line up with your table in game, set `scene` (and optionally `surgeon`)
on that table in `Config.Tables`. The major surgery code is based on pickle_surgery by Pickle Mods,
see `CREDITS.md` and `LICENSE`.

Each procedure is a progress bar followed by an ox_lib skill check. Failing the skill check causes a
complication (extra bleeding + pain) and the step has to be done again.

Everything is logged to the patient's OSP message log.

## Config notes
- `Config.Procedures.*.item` / `removeItem` — require (and use up) an ox_inventory item.
- `Config.Procedures.*.minGrade` — lock a procedure to higher grades.
- `Config.BulletItem` — give the surgeon an evidence item per bullet removed.
- `Config.AllowDowned = false` — only operate on stabilised patients.
