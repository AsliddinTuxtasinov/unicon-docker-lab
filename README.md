# unicon-docker-lab

## Task qoʻshish bo'yicha yoʻriqnoma

1. **Yangi task papkasini yarating**
   - `tasks/` ichida tegishli blok uchun yangi papka yarat:
     - masalan: `tasks/01-basics/03-new-task/`

2. **`task.yaml` faylini yozing**
   - yangi papkada `task.yaml` yarat.
   - format shunga o‘xshash bo‘lishi kerak:

```yaml
id: docker-your-task-id
title: "Task sarlavhasi"
difficulty: beginner
estimated_minutes: 5

setup:
  - "docker pull busybox 2>/dev/null || true"

verify:
  steps:
    - type: exec
      command: "docker images | grep busybox"
      exit_code: 0
      error_message: "busybox image topilmadi"
```

3. **`setup.sh` faylini qoʻshing**
   - papkada `setup.sh` ham bo‘lishi kerak.
   - misol:

```bash
#!/usr/bin/env bash
set -e
timeout 30 bash -c 'until docker info &>/dev/null; do sleep 1; done'
```

4. **`_meta.yaml` ga taskni qoʻshing**
   - `tasks/01-basics/_meta.yaml` faylini oching.
   - `tasks:` ro‘yxatiga yangi papka nomini qo‘shing:

```yaml
tasks:
  - 01-hello-world
  - 02-pull-image
  - 03-new-task
```

5. **(Ixtiyoriy) README.md ga task ro‘yxatini yozing**
   - Bu fayl faqat dokumentatsiya uchun kerak.
   - Misol:

```md
## 01 Basics

- `tasks/01-basics/01-hello-world` — Hello World konteyner ishga tushur
- `tasks/01-basics/02-pull-image` — nginx image ni yuklab ol
```

> Eslatma: tasklar haqiqatan ham `tasks/.../task.yaml` va `_meta.yaml` orqali aniqlanadi. `README.md` esa faqat qoʻshimcha ma'lumot beradi.
 
