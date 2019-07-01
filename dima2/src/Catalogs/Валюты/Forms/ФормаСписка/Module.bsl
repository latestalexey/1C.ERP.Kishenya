
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДатаКурса = НачалоДня(ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", ДатаКурса);
	Список.Параметры.УстановитьЗначениеПараметра("ПояснениеКратности", НСтр("ru='грн. за';uk='грн. за'"));
	
	Элементы.Валюты.РежимВыбора = Параметры.РежимВыбора;
	
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеКурсовВалют") Тогда
		Элементы.ФормаПодборИзКВ.Видимость = Ложь;
		Элементы.ФормаЗагрузитьКурсыВалют.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Элементы.Валюты.ИзменятьСоставСтрок = Ложь;
		Элементы.ФормаПодборИзКВ.Видимость = Ложь;
		Элементы.ФормаЗагрузитьКурсыВалют.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Элементы.Валюты.Обновить();
	Элементы.Валюты.ТекущаяСтрока = РезультатВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КурсыВалют"
		Или ИмяСобытия = "Запись_ЗагрузкаКурсовВалют" Тогда
		Элементы.Валюты.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВалюты

&НаКлиенте
Процедура ВалютыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Текст = НСтр("ru='Есть возможность подобрать валюту из классификатора.
    |Подобрать?'
    |;uk='Є можливість підібрати валюту із класифікатора.
    |Підібрати?'");
	Оповещение = Новый ОписаниеОповещения("ВалютыПередНачаломДобавленияЗавершение", ЭтотОбъект);
	КнопкиВыбора = Новый СписокЗначений();
	КнопкиВыбора.Добавить(КодВозвратаДиалога.Да, "Подобрать");
	КнопкиВыбора.Добавить(КодВозвратаДиалога.Нет, "Создать");
	КнопкиВыбора.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
	ПоказатьВопрос(Оповещение, Текст,КнопкиВыбора, , КодВозвратаДиалога.Да);
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИзКВ(Команда)		
	
	ОткрытьФорму("Справочник.Валюты.Форма.ПодборВалютИзКлассификатора",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВалютыПередНачаломДобавленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	 
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОткрытьФорму("Справочник.Валюты.Форма.ПодборВалютИзКлассификатора", , ЭтотОбъект);
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ОткрытьФорму("Справочник.Валюты.ФормаОбъекта");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
