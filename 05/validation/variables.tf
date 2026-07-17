# ─────────────────────────────────────────────────────────────────────────────
# Задание 4: переменные с валидацией ip-адресов.
# ─────────────────────────────────────────────────────────────────────────────

variable "vm_ip" {
  type        = string
  description = "ip-адрес"
  default     = "192.168.0.1"

  # cidrhost() разбирает префикс и возвращает адрес хоста по номеру. Маска /32 —
  # это ровно один адрес, поэтому корректный ip даёт cidrhost(ip/32, 0) == ip,
  # а мусор вроде 1920.1680.0.1 функцию роняет. can() ловит это падение и
  # превращает в false — на нём и строится проверка.
  validation {
    condition     = can(cidrhost("${var.vm_ip}/32", 0))
    error_message = "Переменная vm_ip должна содержать корректный IPv4-адрес, например 192.168.0.1."
  }
}

variable "vm_ip_list" {
  type        = list(string)
  description = "список ip-адресов"
  default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]

  # Тот же приём, но для каждого элемента: alltrue() требует, чтобы проверку
  # прошли все адреса — одного битого достаточно, чтобы валидация упала.
  validation {
    condition     = alltrue([for ip in var.vm_ip_list : can(cidrhost("${ip}/32", 0))])
    error_message = "Каждый элемент vm_ip_list должен быть корректным IPv4-адресом."
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Задание 5*: валидация строки и объекта.
# ─────────────────────────────────────────────────────────────────────────────

variable "any_string" {
  type        = string
  description = "любая строка"
  default     = "netology terraform"

  # Строка без символов верхнего регистра совпадает сама с собой после lower().
  # Сравнение с lower() надёжнее regex вида ^[^A-Z]*$: оно ловит верхний регистр
  # не только в латинице, но и в кириллице и любом другом юникоде.
  validation {
    condition     = var.any_string == lower(var.any_string)
    error_message = "Строка any_string не должна содержать символов верхнего регистра."
  }
}

variable "in_the_end_there_can_be_only_one" {
  description = "Who is better Connor or Duncan?"
  type = object({
    Dunkan = optional(bool)
    Connor = optional(bool)
  })

  default = {
    Dunkan = true
    Connor = false
  }

  # Горец должен остаться один: ровно одно значение true и ровно одно false.
  # Проверки на null обязательны из-за optional(bool) — незаданное поле
  # приходит как null, и без них пара {Dunkan = true} проскочила бы:
  # true != null истинно, хотя второго горца не объявили вовсе.
  validation {
    error_message = "There can be only one MacLeod"
    condition = (
      var.in_the_end_there_can_be_only_one.Dunkan != null &&
      var.in_the_end_there_can_be_only_one.Connor != null &&
      var.in_the_end_there_can_be_only_one.Dunkan != var.in_the_end_there_can_be_only_one.Connor
    )
  }
}
