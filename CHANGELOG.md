# 📋 CHANGELOG — EclipseLib

## v5.4.0 — Refactored Architecture
**Released:** 2026

### 🔴 Bug Fixes (Critical)
- **แก้ Heartbeat leak** — `AddButton`, `AddProgressBar`, `AddInfoCard` เปลี่ยนจาก `RunService.Heartbeat` เป็น `task.spawn` + `task.wait(0.1)` ลด CPU/FPS drop ได้มากบนมือถือ
- **แก้ Config encode พัง** — เปลี่ยน encoder เป็นแบบที่ escape `=`, `\n`, `\\` ถูกต้อง
- **แก้ Draggable connection stack** — เก็บ connections ไว้ใน `_connections` table cleanup ตอน `Destroy()`
- **Cache MarketplaceService** — ไม่เรียก HTTP request ทุก frame อีกต่อไป

### 🟡 Improvements
- **Notification Queue** — ระบบ queue ป้องกัน notification stack ทับกัน (MAX 4 อัน)
- **Paragraph AutomaticSize** — ใช้ `Enum.AutomaticSize.Y` แทนการคำนวณด้วยมือ
- **Draggable Touch Threshold** — เพิ่ม 5px minimum threshold ป้องกัน UI กระตุกบนมือถือ

### 🟢 New
- **Module Architecture** — แยกโค้ดเป็น 6 modules: `Utility`, `ThemeSystem`, `ConfigSystem`, `Notification`, `Intro`, `KeySystem`
- **Loader.lua** — loadstring entry point จาก GitHub raw URL
- **ThemeRegistry ครบ** — เพิ่ม `sliderFills` registry ใน ThemeSystem

---

## v5.3.0 — Initial Release
- EclipseLib พร้อม Intro, Theme, Config, KeySystem, Notification
- รองรับ Mobile (Touch)
- 6 Preset Themes
- ColorPicker RGB Sliders
