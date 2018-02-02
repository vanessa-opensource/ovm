# OneScript Version Manager

[![Quality Gate](https://sonar.silverbulleters.org/api/badges/gate?key=sonar-opensource-add-ovm)](https://sonar.silverbulleters.org/dashboard?id=sonar-opensource-add-ovm)
[![Tech Debt](https://sonar.silverbulleters.org/api/badges/measure?key=sonar-opensource-add-ovm&metric=sqale_debt_ratio)](https://sonar.silverbulleters.org/dashboard?id=sonar-opensource-add-ovm)

```
Приложение: ovm
 OneScript Version Manager v1.0.0

Строка запуска: ovm [OPTIONS] КОМАНДА [аргументы...]

Опции:
  -v, --version         показать версию и выйти

Доступные команды:
  install, i            Установить OneScript указанных версий
  use, u                Использовать OneScript указанной версии
  uninstall, delete, d  Удалить OneScript указанных версий
  list, ls              Вывести список установленных и/или доступных версий OneScript
  run, r                Запустить исполняемый файл в окружении указанной версии OneScript
  which, w              Вывести путь к установленной версии OneScript
  migrate               Поместить установленный системный OneScript под контроль ovm. Только для Windows

Для вывода справки по доступным командам наберите: ovm КОМАНДА --help
```
