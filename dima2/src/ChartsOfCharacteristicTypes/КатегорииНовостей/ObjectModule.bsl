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

	// Запретить сохранять смешанные типы, т.е. ТипЗначения - составной.
	Если ЭтотОбъект.ТипЗначения.Типы().Количество() > 1 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "ТипЗначения";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = НСтр("ru='Составные типы не поддерживаются. Выберите только один тип значения.';uk='Складові типи не підтримуються. Виберіть тільки один тип значення.'");
		Сообщение.Сообщить();
	КонецЕсли;

	// Запретить сохранять пустые типы, т.е. ТипЗначения - пустой.
	Если ЭтотОбъект.ТипЗначения.Типы().Количество() = 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "ТипЗначения";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = НСтр("ru='Пустые типы не поддерживаются. Выберите один любой тип значения.';uk='Порожні типи не підтримуються. Виберіть один будь-який тип значення.'");
		Сообщение.Сообщить();
	КонецЕсли;

	// Возможно, что заполнен реквизит ТипЗначенияВспомогательный, но не заполнен ТипЗначения - исправить.
	Если ЭтотОбъект.ТипЗначения.Типы().Количество() = 0 Тогда
		Если ЭтотОбъект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Булево Тогда
			ЭтотОбъект.ТипЗначения = Новый ОписаниеТипов("Булево");
		ИначеЕсли ЭтотОбъект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Дата Тогда
			ЭтотОбъект.ТипЗначения = Новый ОписаниеТипов("Дата");
		ИначеЕсли ЭтотОбъект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Строка Тогда
			ЭтотОбъект.ТипЗначения = Новый ОписаниеТипов("Строка");
		ИначеЕсли ЭтотОбъект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Число Тогда
			ЭтотОбъект.ТипЗначения = Новый ОписаниеТипов("Число");
		ИначеЕсли ЭтотОбъект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ЗначенияКатегорийНовостей Тогда
			ЭтотОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияКатегорийНовостей");
		ИначеЕсли ЭтотОбъект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ИнтервалыВерсийПродукта Тогда
			ЭтотОбъект.ТипЗначения = Новый ОписаниеТипов("Строка");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	ЭтотОбъект.Код          = СокрЛП(ЭтотОбъект.Код);
	ЭтотОбъект.Наименование = СокрЛП(ЭтотОбъект.Наименование);

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтотОбъект.ЗагруженоССервера = Истина Тогда
		// Нельзя пометить на удаление категорию, загруженную с сервера.
		Если (ЭтотОбъект.ПометкаУдаления = Истина)
				И (Ссылка.ПометкаУдаления = Ложь) Тогда
			ТекстСообщения = НСтр("ru='Нельзя помечать на удаление категории, загруженные автоматически с сервера новостей.';uk='Не можна позначати на видалення категорії, автоматично завантажені з сервера новин.'");
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.УстановитьДанные(Ссылка);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли