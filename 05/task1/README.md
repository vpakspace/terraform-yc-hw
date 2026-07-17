# Код для задания 1 — объект проверки линтерами

Здесь лежит **чужой код**, скопированный без единой правки из официального репозитория
[`netology-code/ter-homeworks`](https://github.com/netology-code/ter-homeworks):

| Каталог | Источник |
|---|---|
| [`hw04-src/`](hw04-src) | [`04/src`](https://github.com/netology-code/ter-homeworks/tree/main/04/src) — ДЗ к лекции 4 |
| [`demonstration1/`](demonstration1) | [`04/demonstration1`](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) — демо к лекции 4 |

Он нужен, чтобы прогон `tflint` и `checkov` из задания 1 можно было воспроизвести
командой, а не принимать на веру. Отчёты линтеров — в [`reports/`](reports),
разбор найденных типов ошибок — в [`../README.md`](../README.md#задание-1--проверка-кода-tflint-и-checkov).

> **Ошибки в этом каталоге исправлять не нужно — они и есть результат задания 1.**
> Задание 3 (ветка `terraform-hotfix`) правит только собственный код: `05/src`,
> `05/backend-infra`, `05/validation`.

Проект не инициализировался (`terraform init` не выполнялся) — как и требует задание:
оба линтера работают со статическим анализом HCL.

```bash
cd 05/task1
tflint --recursive --format compact
checkov -d . --compact --quiet
```
