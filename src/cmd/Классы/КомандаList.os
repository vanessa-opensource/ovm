#Использовать "../../core"

Перем ВерсииOneScript;

Процедура ОписаниеКоманды(КомандаПриложения) Экспорт
	
	КомандаПриложения.Опция("remote r", Ложь, "Вывести список доступных к установке версий").Флаговый();
	КомандаПриложения.Опция("quiet q", Ложь, "Тихий режим, вывод только алиасов версий");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
	
	ВыводитьСписокВерсийНаСайте = КомандаПриложения.ЗначениеОпции("--remote");
	ТихийРежим = КомандаПриложения.ЗначениеОпции("--quiet");

	Если ВыводитьСписокВерсийНаСайте Тогда
		ВывестиСписокДоступныхКУстановкеВерсий(ТихийРежим);
	Иначе
		ВывестиСписокУстановленныхВерсий(ТихийРежим);
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиСписокУстановленныхВерсий(Знач ТихийРежим)
	СписокУстановленныхВерсий = ВерсииOneScript.ПолучитьСписокУстановленныхВерсий();
	Для Каждого УстановленнаяВерсия Из СписокУстановленныхВерсий Цикл
		Если ТихийРежим Тогда
			Сообщение = УстановленнаяВерсия.Алиас;
		Иначе
			Сообщение = СтрШаблон("%1 -> %2 (%3)", УстановленнаяВерсия.Алиас, УстановленнаяВерсия.Версия, УстановленнаяВерсия.Путь);
		КонецЕсли;	
		УстанавливаемыйСтатусСообщения = ?(УстановленнаяВерсия.Алиас = "current", СтатусСообщения.Информация, СтатусСообщения.БезСтатуса);
		Сообщить(Сообщение, УстанавливаемыйСтатусСообщения);
	КонецЦикла;
КонецПроцедуры

Процедура ВывестиСписокДоступныхКУстановкеВерсий(Знач ТихийРежим)
	
	СписокДоступныВерсий = ВерсииOneScript.ПолучитьСписокДоступныхКУстановкеВерсий();
	Для Каждого ДоступнаяВерсия Из СписокДоступныВерсий Цикл
		Если ТихийРежим Тогда
			Сообщение = ДоступнаяВерсия.Алиас;
		Иначе
			Сообщение = СтрШаблон("%1 (%2)", ДоступнаяВерсия.Алиас, ДоступнаяВерсия.Путь);
		КонецЕсли;	
		Сообщить(Сообщение);
	КонецЦикла;

КонецПроцедуры

ВерсииOneScript = Новый ВерсииOneScript();