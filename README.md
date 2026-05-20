# Tasks — Qo'llanma

Bu papka Docker Lab platformasining barcha o'quv vazifalarini o'z ichiga oladi.

---

## Papka tuzilmasi

```
tasks/
├── README.md                        ← shu fayl
├── 01-basics/
│   ├── _meta.yaml                   ← bo'lim meta-ma'lumotlari
│   ├── 01-hello-world/
│   │   ├── task.yaml                ← vazifa ta'rifi
│   │   └── setup.sh                 ← ixtiyoriy: bash orqali tayyorlov
│   └── 02-pull-image/
│       ├── task.yaml
│       └── setup.sh
└── 02-docker-course/
    ├── _meta.yaml
    ├── 01-intro/
    │   ├── task.yaml
    │   └── setup.sh
    └── ...
```

**Nima uchun bunday tuzilma?**
Papka nomi (`01-basics`, `02-docker-course`) tartib raqami bilan boshlanadi — sistem ularni alifbo tartibida o'qiydi, shuning uchun raqam = ko'rsatilish tartibi. `_meta.yaml` bo'lim ichidagi vazifalar tartibini aniqlab beradi.

---

## `_meta.yaml` formati

```yaml
id: basics          # bo'limning unikal identifikatori (API da section_id sifatida ishlatiladi)
order: 1            # bo'limlar orasidagi tartib (hozircha ma'lumot uchun, papka nomi amalda tartibni belgilaydi)
tasks:              # vazifa papkalarining tartiblangan ro'yxati
  - 01-hello-world
  - 02-pull-image
```

**Nima uchun `tasks` ro'yxati kerak?**
Papka ichidagi papkalar fayl sistemasi tartibida ko'rinishi kafolatlanmaydi (ayniqsa Windows/Linux farqlari bor). `tasks:` ro'yxati orqali siz tartibni to'liq nazorat qilasiz. Agar papka bor-u ro'yxatda yo'q bo'lsa — sistem uni o'tkazib yuboradi (yashirin/tayyorlanmagan vazifalar uchun qulay).

---

## `task.yaml` formati

```yaml
id: docker-run-hello-world          # global unikal ID — hech qachon o'zgartirmang
title: "Hello World konteyner ishga tushir"
description: "Foydalanuvchiga ko'rsatiladigan topshiriq matni. Aniq buyruq yozing."
difficulty: beginner                # beginner | intermediate | advanced
estimated_minutes: 5

setup:
  - "docker pull hello-world 2>/dev/null || true"

verify:
  steps:
    - type: exec
      command: "docker ps -a | grep hello-world"
      exit_code: 0
      error_message: "hello-world konteyner ishlatilmagan"
```

### Har bir maydon haqida

**`id`** — global unikal bo'lishi shart. Foydalanuvchi progressi shu ID ga bog'liq. O'zgartirilsa — barcha foydalanuvchilar uchun progress yo'qoladi.

**`title`** — qisqa sarlavha. UI da ro'yxatda ko'rinadi.

**`description`** — foydalanuvchiga ko'rsatiladigan asosiy topshiriq matni. **Aniq buyruq yozing** — foydalanuvchi nima bajarish kerakligini bilishi kerak. Noto'g'ri misol: *"Docker haqida o'rganing"*. To'g'ri misol: *"`docker run --name mytest alpine:3.18 echo done` bajaring"*.

**`difficulty`** — UI da filtrlash uchun ishlatiladi. Uch qiymat: `beginner`, `intermediate`, `advanced`.

**`estimated_minutes`** — taxminiy vaqt. UI da ko'rsatiladi.

---

## `setup` — tayyorlov bosqichi

```yaml
setup:
  - "docker pull alpine:3.18 2>/dev/null || true"
  - "mkdir -p /tmp/workdir"
```

**Nima qiladi?** Foydalanuvchi vazifani boshlagan zahoti, yangi toza konteyner yaratiladi va bu buyruqlar o'sha konteynerda bajariladi.

**Qoidalar:**
- `setup` foydalanuvchiga **ko'rinmaydi** — u faqat muhitni tayyorlaydi
- `2>/dev/null || true` — agar buyruq muvaffaqiyatsiz bo'lsa ham vazifa boshlanadi (image allaqachon mavjud bo'lsa xato chiqmasin)
- Image pull qilish uchun mos: foydalanuvchi kutib o'tirmasin
- `setup` **hech qachon** `verify` da tekshiriladigan narsani yaratmasin (aks holda foydalanuvchi hech narsa qilmasa ham verify o'tadi)

**`setup.sh` fayl** — `setup` ro'yxatidan murakkabroq tayyorlov uchun. Agar papkada `setup.sh` mavjud bo'lsa, avval shu skript ishga tushadi, keyin `setup:` ro'yxatidagi buyruqlar.

---

## `verify` — tekshiruv bosqichi

Foydalanuvchi "Verify" tugmasini bosganda, barcha steplar **foydalanuvchining konteynerida** ketma-ket bajariladi. Birinchi muvaffaqiyatsiz step — vazifa bajarilmadi deb hisoblanadi va `error_message` foydalanuvchiga ko'rsatiladi.

### Step turlari

**`exec`** — eng ko'p ishlatiladigan tur. Buyruq bajariladi va exit code tekshiriladi.
```yaml
- type: exec
  command: "docker ps -a --filter name=mytest --format '{{.Names}}' | grep mytest"
  exit_code: 0
  error_message: "'docker run --name mytest ...' bajaring"
```

**`file_exists`** — fayl mavjudligini tekshiradi.
```yaml
- type: file_exists
  path: "/tmp/myapp/Dockerfile"
  error_message: "Dockerfile topilmadi"
```

**`port_open`** — localhost portini tekshiradi (servis ishlaydimi).
```yaml
- type: port_open
  port: 8080
  error_message: "8080 port ochiq emas"
```

**`container_running`** — konteyner ishlayaptimi tekshiradi.
```yaml
- type: container_running
  command: "myapp"
  error_message: "myapp konteyner ishlamayapti"
```

---

## Verify yozishda asosiy xatolar

### ❌ Xato: Setup qilgan narsani verify qilish

```yaml
setup:
  - "docker pull alpine:3.18 2>/dev/null || true"   # alpine pull qildi

verify:
  steps:
    - type: exec
      command: "docker images | grep alpine"          # setup allaqachon qildi — AVTO-PASS
```

Foydalanuvchi hech narsa qilmasa ham verify o'tadi. **Yechim:** verify foydalanuvchi o'zi yaratishi kerak bo'lgan narsa — nomlangan konteyner, fayl, volume, network — ni tekshirsin.

### ❌ Xato: Verify o'zi buyruqni bajarishi

```yaml
verify:
  steps:
    - type: exec
      command: "docker run --rm alpine:3.18 echo ok | grep ok"   # verify o'zi run qildi
```

Verifier konteyner yaratdi, o'zi grep qildi — foydalanuvchi hech narsa qilmadi. **Yechim:** verify faqat **holatni** tekshirsin, buyruqni o'zi bajarmsin.

### ❌ Xato: Har doim o'tadigan buyruqlar

```yaml
verify:
  steps:
    - type: exec
      command: "docker --version"    # docker o'rnatilgan bo'lsa har doim o'tadi
    - type: exec
      command: "docker ps"           # har doim o'tadi
    - type: exec
      command: "docker network ls | grep bridge"   # bridge har doim mavjud
```

### ✅ To'g'ri: Foydalanuvchi yaratgan artifaktni tekshirish

```yaml
# Foydalanuvchi: docker run --name mytest alpine:3.18 echo done
verify:
  steps:
    - type: exec
      command: "docker ps -a --filter name=mytest --format '{{.Names}}' | grep mytest"
      exit_code: 0
      error_message: "'docker run --name mytest alpine:3.18 echo done' bajaring"

# Foydalanuvchi: docker volume create mydata
verify:
  steps:
    - type: exec
      command: "docker volume ls --format '{{.Name}}' | grep -x 'mydata'"
      exit_code: 0
      error_message: "'docker volume create mydata' bajaring"

# Foydalanuvchi: echo 'SECRET=x' > /tmp/.env
verify:
  steps:
    - type: exec
      command: "test -f /tmp/.env && grep 'SECRET' /tmp/.env"
      exit_code: 0
      error_message: "/tmp/.env faylida SECRET yo'q"
```

---

## Texnik arxitektura

```
Foydalanuvchi "Start" bosadi
        ↓
Eski konteyner o'chiriladi (har vazifa uchun toza muhit)
        ↓
Yangi konteyner yaratiladi (lab image asosida)
        ↓
setup.sh + setup: buyruqlari konteynerda bajariladi
        ↓
Foydalanuvchi terminal orqali konteynerda ishlaydi
        ↓
Foydalanuvchi "Verify" bosadi
        ↓
verify.steps buyruqlari shu konteynerda bajariladi
        ↓
Barcha steplar o'tsa → passed: true
Birinchi muvaffaqiyatsiz step → passed: false + error_message
```

**Nima uchun har vazifada yangi konteyner?**
Avvalgi vazifaning "ifloslangan" muhiti keyingi vazifaga ta'sir qilmasin. Har bir vazifa mustaqil, toza holatdan boshlanadi.

---

## Yangi vazifa qo'shish

1. Bo'lim papkasida yangi papka yarating: `XX-task-name/`
2. `task.yaml` yarating (yuqoridagi format bo'yicha)
3. `setup.sh` qo'shing (agar kerak bo'lsa)
4. Bo'limning `_meta.yaml` dagi `tasks:` ro'yxatiga qo'shing

**Tekshirish ro'yxati:**
- [ ] `id` global unikal
- [ ] `description` da aniq buyruq ko'rsatilgan
- [ ] `setup` verify da tekshiriladigan narsani yaratmaydi
- [ ] `verify` foydalanuvchi qilgan harakatning IZINI tekshiradi (not the action itself)
- [ ] `error_message` foydalanuvchiga qaysi buyruqni bajarishni aytadi
- [ ] `_meta.yaml` dagi ro'yxatga qo'shilgan
