
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	МожноОбновлятьКлассификатор =
		Не ОбщегоНазначенияПовтИсп.РазделениеВключено() // В модели сервиса обновляется автоматически.
		И Не ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ()   // В узле РИБ обновляется автоматически.
		И ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторБанков); // Пользователь с необходимыми правами.

	Элементы.ФормаПодобратьИзКлассификатора.Видимость = МожноОбновлятьКлассификатор;
	
	ПереключитьВидимостьНедействующихБанков(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Текст = НСтр("ru='Есть возможность подобрать из классификатора банков
        |Подобрать?'
        |;uk='Є можливість підібрати з класифікатора банків
        |Підібрати?'");
		
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ДополнительныеПараметры.Вставить("ЗначениеКопирования", Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПодобратьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)	
	ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаПодбораИзКлассификатора",,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействующиеБанки(Команда)
	ПереключитьВидимостьНедействующихБанков(Не Элементы.ФормаПоказыватьНедействующиеБанки.Пометка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереключитьВидимостьНедействующихБанков(Видимость)
	
	Элементы.ФормаПоказыватьНедействующиеБанки.Пометка = Видимость;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ДеятельностьПрекращена", Ложь, , , Не Видимость);
			
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеятельностьПрекращена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПодобратьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаЭлемента", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
