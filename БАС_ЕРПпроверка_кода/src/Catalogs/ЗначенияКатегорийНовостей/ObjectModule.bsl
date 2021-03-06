#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// В идентификаторе (Код) допустимы только английские символы, подчеркивания, минус и числа.
	РазрешенныеСимволы = ОбработкаНовостейКлиентСервер.ПолучитьРазрешенныеДляИдентификацииСимволы();
	СписокЗапрещенныхСимволов = ОбработкаНовостейКлиентСервер.ПроверитьИдентификаторНаЗапрещенныеСимволы(
		СокрЛП(ЭтотОбъект.Код),
		РазрешенныеСимволы);

	Если СписокЗапрещенныхСимволов.Количество() > 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Код";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = НСтр("ru='В идентификаторе присутствуют запрещенные символы: %СписокЗапрещенныхСимволов%.
            |Разрешено использовать цифры, английские буквы, подчеркивание и минус.'
            |;uk='В ідентифікаторі присутні заборонені символи: %СписокЗапрещенныхСимволов%.
            |Дозволено використовувати цифри, англійські літери, підкреслення і мінус.'");
		Сообщение.Текст = СтрЗаменить(Сообщение.Текст, "%СписокЗапрещенныхСимволов%", СписокЗапрещенныхСимволов);
		Сообщение.Сообщить();
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	ЭтотОбъект.Код          = СокрЛП(ЭтотОбъект.Код);
	ЭтотОбъект.Наименование = СокрЛП(ЭтотОбъект.Наименование);

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

#КонецЕсли