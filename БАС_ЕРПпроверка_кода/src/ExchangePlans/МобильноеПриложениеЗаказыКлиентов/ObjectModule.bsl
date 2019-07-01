#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ТекстНаименование = НСтр("ru='%Пользователь% (""Заказы клиентов"")';uk='%Пользователь% (""Замовлення клієнтів"")'");
		ТекстНаименование = СтрЗаменить(ТекстНаименование, "%Пользователь%", СокрЛП(Пользователь));
		Наименование = ТекстНаименование;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		НовыйКод = СокрЛП(Пользователь.УникальныйИдентификатор());
		ПроверитьНовыйКод(НовыйКод, ЭтотОбъект.Ссылка, Отказ);
		Если Отказ Тогда
			Сообщение = НСтр("ru='Для пользователя ""%Пользователь%"" уже существует настройка,
            |которая еще не была задействована для синхронизации данных с мобильным приложением.
            |Используйте ее для настройки обмена данными.'
            |;uk='Для користувача ""%Пользователь%"" вже існує настройка,
            |яка ще не була задіяна для синхронізації даних з мобільним додатком.
            |Використайте її для настройки обміну даними.'");
			Сообщение = СтрЗаменить(Сообщение, "%Пользователь%", Пользователь);
			Поле = "Пользователь";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, ЭтотОбъект, Поле,, Отказ);
			Возврат;
		Иначе
			Код = НовыйКод;
		КонецЕсли;
	КонецЕсли;
		
	ПрефиксИспользуется = МобильноеПриложениеЗаказыКлиентовПереопределяемый.ПроверитьПрефиксДляДанныхМобильногоУстройства(
		Ссылка, ПрефиксДляДанныхМобильногоУстройства);
	
	Если ПрефиксИспользуется Тогда
		Сообщение = НСтр("ru='Префикс ""%Префикс%"" уже используется !';uk='Префікс ""%Префикс%"" вже використовується !'");
		Сообщение = СтрЗаменить(Сообщение, "%Префикс%", ПрефиксДляДанныхМобильногоУстройства);
		Поле = "ПрефиксДляДанныхМобильногоУстройства";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, ЭтотОбъект, Поле,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ДобавитьНепроверяемыеРеквизитыВМассив(МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = "";
	Наименование = "";
	ПрефиксДляДанныхМобильногоУстройства = "";
	ИдентификаторПодписчикаДоставляемыхУведомлений = Неопределено;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПланыОбмена.УдалитьРегистрациюИзменений(Ссылка);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Код = СокрЛП(Пользователь.УникальныйИдентификатор()) И НЕ ПометкаУдаления Тогда
		ПланыОбмена.ЗарегистрироватьИзменения(Ссылка, Метаданные.Справочники.Партнеры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьНепроверяемыеРеквизитыВМассив(МассивНепроверяемыхРеквизитов)
	
	Если Ссылка = ПланыОбмена.МобильноеПриложениеЗаказыКлиентов.ЭтотУзел() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Пользователь");
		МассивНепроверяемыхРеквизитов.Добавить("ПрефиксДляДанныхМобильногоУстройства");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Код");
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
КонецПроцедуры

Процедура ПроверитьНовыйКод(НовыйКод, СсылкаНаОбъект, Отказ)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МобильноеПриложениеЗаказыКлиентов.Ссылка
	|ИЗ
	|	ПланОбмена.МобильноеПриложениеЗаказыКлиентов КАК МобильноеПриложениеЗаказыКлиентов
	|ГДЕ
	|	НЕ МобильноеПриложениеЗаказыКлиентов.Ссылка = &СсылкаНаОбъект
	|	И МобильноеПриложениеЗаказыКлиентов.Код = &Код");
	
	Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("Код", НовыйКод);
	
	Результат = Запрос.Выполнить();
	
	Отказ = Не Результат.Пустой();
КонецПроцедуры

#КонецОбласти

#КонецЕсли
