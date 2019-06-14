#Использовать 1commands
#Использовать fluent
#Использовать fs
#Использовать logos

Перем Лог;
Перем ЭтоWindows;

// Проверить, что версия установлена
//
// Параметры:
//   ПроверяемаяВерсия - Строка - Алиас версии
//
//  Возвращаемое значение:
//   Булево - Версия установлена
//
Функция ВерсияУстановлена(Знач ПроверяемаяВерсия) Экспорт

	КаталогУстановки = ПараметрыOVM.КаталогУстановкиПоУмолчанию();
	КаталогУстановкиВерсии = ОбъединитьПути(КаталогУстановки, ПроверяемаяВерсия);
	
	Результат = ФС.КаталогСуществует(КаталогУстановкиВерсии);
	Результат = Результат И ФС.ФайлСуществует(ОбъединитьПути(КаталогУстановкиВерсии, "bin", "oscript.exe"));

	Лог.Отладка("Версия %1 установлена: %2", ПроверяемаяВерсия, Результат);
	Возврат Результат;

КонецФункции

// Проверить, что переданная версия является текущей (активированной)
//
// Параметры:
//   ПроверяемаяВерсия - Строка - Алиас
//
//  Возвращаемое значение:
//   Булево - Это текущая версия
//
Функция ЭтоТекущаяВерсия(Знач ПроверяемаяВерсия) Экспорт

	Если ПроверяемаяВерсия = "current" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ВерсияУстановлена("current") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ВерсияУстановлена(ПроверяемаяВерсия) Тогда
		Возврат Ложь;
	КонецЕсли;

	ПутьКДвижкуТекущейВерсии = ПолучитьПутьКУстановленномуДвижкуOneScript("current");
	ПутьКДвижкуПроверяемойВерсии = ПолучитьПутьКУстановленномуДвижкуOneScript(ПроверяемаяВерсия);
	
	ФайлДвижкаТекущейВерсии = Новый Файл(ПутьКДвижкуТекущейВерсии);
	ФайлДвижкаПроверяемойВерсии = Новый Файл(ПутьКДвижкуПроверяемойВерсии);
	
	ФайлыПроверяемойВерсииСовпадаетСТекущейВерсией =
		ФайлДвижкаТекущейВерсии.ПолучитьВремяИзменения() = ФайлДвижкаПроверяемойВерсии.ПолучитьВремяИзменения()
			И ФайлДвижкаТекущейВерсии.ПолучитьВремяСоздания() = ФайлДвижкаПроверяемойВерсии.ПолучитьВремяСоздания();

	Возврат ФайлыПроверяемойВерсииСовпадаетСТекущейВерсией;

КонецФункции

// Получить информацию об установленных версиях
//
//  Возвращаемое значение:
//   ТаблицаЗначений - Информация об установленных версиях:
//		* Алиас - Строка - Алиас версии (имя каталога)
//		* Путь - Строка - Полный путь к каталогу версии
//		* Версия - Строка - Точная версия OneScript
//		* ЭтоСимлинк - Булево - Каталог является символической ссылкой
//
Функция ПолучитьСписокУстановленныхВерсий() Экспорт
	
	УстановленныеВерсии = Новый ТаблицаЗначений;
	УстановленныеВерсии.Колонки.Добавить("Алиас");
	УстановленныеВерсии.Колонки.Добавить("Путь");
	УстановленныеВерсии.Колонки.Добавить("Версия");
	УстановленныеВерсии.Колонки.Добавить("ЭтоСимлинк");
	
	// TODO: определение симлинка на основании аттрибутов файла?
	МассивИменСимлинков = Новый Массив;
	МассивИменСимлинков.Добавить("current");
	
	КаталогУстановки = ПараметрыOVM.КаталогУстановкиПоУмолчанию();
	НайденныеФайлы = НайтиФайлы(КаталогУстановки, ПолучитьМаскуВсеФайлы());
	Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
		Если НЕ ВерсияУстановлена(НайденныйФайл.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаВерсии = УстановленныеВерсии.Добавить();
		СтрокаВерсии.Алиас = НайденныйФайл.Имя;
		СтрокаВерсии.Путь = НайденныйФайл.ПолноеИмя;
		СтрокаВерсии.Версия = ПолучитьТочнуюВерсиюOneScript(СтрокаВерсии.Алиас);
		СтрокаВерсии.ЭтоСимлинк = МассивИменСимлинков.Найти(НайденныйФайл.Имя) <> Неопределено;

	КонецЦикла;
	
	Возврат УстановленныеВерсии;
	
КонецФункции

// Получить информацию о версиях, доступных к установке
//
//  Возвращаемое значение:
//   ТаблицаЗначений - Информация об установленных версиях:
//		* Алиас - Строка - Алиас версии (имя каталога)
//		* Путь - Строка - Полный путь к каталогу версии
//
Функция ПолучитьСписокДоступныхКУстановкеВерсий() Экспорт
	
	ДоступныеВерсии = Новый ТаблицаЗначений;
	ДоступныеВерсии.Колонки.Добавить("Алиас");
	ДоступныеВерсии.Колонки.Добавить("Путь");
	
	АдресСайтаОСкрипт = ПараметрыOVM.АдресСайтаОСкрипт();
	
	Соединение = Новый HTTPСоединение(АдресСайтаОСкрипт);
	Запрос = Новый HTTPЗапрос("downloads/archive");
	
	Ответ = Соединение.Получить(Запрос);
	HTTP_OK = 200;
	Если Ответ.КодСостояния <> HTTP_OK Тогда
		ВызватьИсключение Ответ.КодСостояния;
	КонецЕсли;
	
	ТелоСтраницы = Ответ.ПолучитьТелоКакСтроку();
	
	РегулярноеВыражение = Новый РегулярноеВыражение("<a href=""(\/downloads\/[^""]+)"">(\d+\.\d+\.\d+(\.\d+)?)");
	ИндексГруппыАдрес = 1;
	ИндексГруппыВерсия = 2;

	Совпадения = РегулярноеВыражение.НайтиСовпадения(ТелоСтраницы);
	Для Каждого СовпадениеРегулярногоВыражения Из Совпадения Цикл
		ГруппаАдрес = СовпадениеРегулярногоВыражения.Группы[ИндексГруппыАдрес];
		ГруппаВерсия = СовпадениеРегулярногоВыражения.Группы[ИндексГруппыВерсия];
		
		// TODO: Убрать после решения https://github.com/EvilBeaver/OneScript/issues/667
		Если ГруппаВерсия.Значение = "1.0.9" Тогда
			Продолжить;
		КонецЕсли;

		ДоступнаяВерсия = ДоступныеВерсии.Добавить();
		ДоступнаяВерсия.Алиас = ГруппаВерсия.Значение;
		ДоступнаяВерсия.Путь = АдресСайтаОСкрипт + ГруппаАдрес.Значение;
	КонецЦикла;

	ОбеспечитьСтрокуВерсииПоАлиасу(ДоступныеВерсии, "dev", "Путь");
	ОбеспечитьСтрокуВерсииПоАлиасу(ДоступныеВерсии, "stable", "Путь");

	Возврат ДоступныеВерсии;

КонецФункции

// <Описание функции>
//
//  Возвращаемое значение:
//   ТаблицаЗначений - Информация об установленных версиях:
//		* Алиас - Строка - Алиас версии (имя каталога)
//		* ПутьЛокальный - Строка - Полный путь к каталогу версии
//		* ПутьСервер - Строка - Полный путь к каталогу версии на сайте OneScript
//		* Версия - Строка - Точная версия OneScript (только для установленных версий)
//		* ЭтоСимлинк - Булево - Каталог является символической ссылкой
//		* ВерсияУстановлена - Булево - Установлена ли текущая версия
//
Функция ПолучитьСписокВсехВерсий() Экспорт

	СписокУстановленныхВерсий = ПолучитьСписокУстановленныхВерсий();
	СписокДоступныхВерсий = ПолучитьСписокДоступныхКУстановкеВерсий();

	ВсеВерсии = Новый ТаблицаЗначений;
	ВсеВерсии.Колонки.Добавить("Алиас", Новый ОписаниеТипов("Строка"));
	ВсеВерсии.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка"));
	ВсеВерсии.Колонки.Добавить("ПутьЛокальный", Новый ОписаниеТипов("Строка"));
	ВсеВерсии.Колонки.Добавить("ПутьСервер", Новый ОписаниеТипов("Строка"));
	ВсеВерсии.Колонки.Добавить("ЭтоСимлинк", Новый ОписаниеТипов("Булево"));
	ВсеВерсии.Колонки.Добавить("ВерсияУстановлена", Новый ОписаниеТипов("Булево"));

	Для Каждого ДоступнаяВерсия Из СписокДоступныхВерсий Цикл		
		СтрокаВсеВерсии = ВсеВерсии.Найти(ДоступнаяВерсия.Алиас, "Алиас");
		Если СтрокаВсеВерсии = Неопределено Тогда
			СтрокаВсеВерсии = ВсеВерсии.Добавить();
			СтрокаВсеВерсии.Алиас = ДоступнаяВерсия.Алиас;
			СтрокаВсеВерсии.ЭтоСимлинк = Ложь;	
		КонецЕсли;
		
		СтрокаВсеВерсии.ПутьСервер = ДоступнаяВерсия.Путь;
	КонецЦикла;

	Для Каждого УстановленнаяВерсия Из СписокУстановленныхВерсий Цикл	
		СтрокаВсеВерсии = ВсеВерсии.Найти(УстановленнаяВерсия.Алиас, "Алиас");
		Если СтрокаВсеВерсии = Неопределено Тогда
			СтрокаВсеВерсии = ВсеВерсии.Добавить();
			СтрокаВсеВерсии.Алиас = УстановленнаяВерсия.Алиас;
			СтрокаВсеВерсии.ЭтоСимлинк = УстановленнаяВерсия.ЭтоСимлинк;	
		КонецЕсли;
		
		СтрокаВсеВерсии.Версия = УстановленнаяВерсия.Версия;
		СтрокаВсеВерсии.ПутьЛокальный = УстановленнаяВерсия.Путь;
		СтрокаВсеВерсии.ВерсияУстановлена = Истина;
	КонецЦикла;
	
	ОбеспечитьСтрокуВерсииПоАлиасу(ВсеВерсии, "dev");
	ОбеспечитьСтрокуВерсииПоАлиасу(ВсеВерсии, "stable");

	ВсеВерсии.Сортировать("Алиас");
	
	Возврат ВсеВерсии;

КонецФункции

// Получить полный путь к установленному движку OneScript (файлу oscript.exe)
//
// Параметры:
//   УстановленнаяВерсия - Строка - Алиас проверяемой версии
//
//  Возвращаемое значение:
//  Строка - Полный путь к файлу oscript.exe
//
Функция ПолучитьПутьКУстановленномуДвижкуOneScript(Знач УстановленнаяВерсия) Экспорт
	
	УстановленныеВерсии = ПолучитьСписокУстановленныхВерсий();
	
	ПутьКУстановленнойВерсии = ПроцессорыКоллекций.ИзКоллекции(УстановленныеВерсии)
		.Фильтровать(
			"Результат = Элемент.Алиас = ДополнительныеПараметры.УстановленнаяВерсия", 
			Новый Структура("УстановленнаяВерсия", УстановленнаяВерсия))
		.Первые(1)
		.Обработать("Результат = ОбъединитьПути(Элемент.Путь, ""bin"", ""oscript.exe"")")
		.ПолучитьПервый();
	
	Возврат ПутьКУстановленнойВерсии;
	
КонецФункции

Процедура ОбеспечитьСтрокуВерсииПоАлиасу(ТаблицаВерсий, Алиас, ИмяРеквизитаПуть = "ПутьСервер")
	
	СтрокаВерсии = ТаблицаВерсий.Найти(Алиас, "Алиас"); 

	Если СтрокаВерсии = Неопределено Тогда
		СтрокаВерсии = ТаблицаВерсий.Добавить();
		СтрокаВерсии.Алиас = Алиас;
	КонецЕсли;

	СтрокаВерсии[ИмяРеквизитаПуть] = ПараметрыOVM.ПолныйАдресККаталогуДистрибутивов();

КонецПроцедуры

Функция ПолучитьТочнуюВерсиюOneScript(Знач ПроверяемаяВерсия)

	КаталогУстановки = ПараметрыOVM.КаталогУстановкиПоУмолчанию();
	КаталогУстановкиВерсии = ОбъединитьПути(КаталогУстановки, ПроверяемаяВерсия);
	ПутьКИсполняемомуФайлу = ОбъединитьПути(КаталогУстановкиВерсии, "bin", "oscript.exe");
	
	Команда = Новый Команда();
	
	Если ЭтоWindows Тогда
		Команда.УстановитьКоманду(ПутьКИсполняемомуФайлу);
	Иначе
		Команда.УстановитьКоманду("mono");
		Команда.ДобавитьПараметр(ПутьКИсполняемомуФайлу);
	КонецЕсли;
	
	Команда.ДобавитьПараметр("-version");
	
	Команда.Исполнить();
	
	ВыводКоманды = СокрЛП(Команда.ПолучитьВывод());
	Если СтрЧислоСтрок(ВыводКоманды) > 1 Тогда
		РегулярноеВыражение = Новый РегулярноеВыражение("Version (\d+\.\d+\.\d+\.\d+)");
		Совпадения = РегулярноеВыражение.НайтиСовпадения(ВыводКоманды);
		Если Совпадения.Количество() = 1 Тогда
			ВыводКоманды = Совпадения[0].Группы[1].Значение;
		Иначе
			ВыводКоманды = "unknown";
		КонецЕсли;
	КонецЕсли;

	Возврат ВыводКоманды;
	
КонецФункции

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;
// TODO: После фикса движка вернуться на получение лога из ПараметровOVM
Лог = Логирование.ПолучитьЛог("oscript.app.ovm");
