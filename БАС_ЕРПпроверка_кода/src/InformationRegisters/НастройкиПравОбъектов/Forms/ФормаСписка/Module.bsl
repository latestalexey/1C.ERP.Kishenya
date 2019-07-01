
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Чтение = Истина;
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВспомогательныеДанныеРегистра(Команда)
	
	ЕстьИзменения = Ложь;
	
	ОбновитьВспомогательныеДанныеРегистраНаСервере(ЕстьИзменения);
	
	Если ЕстьИзменения Тогда
		Текст = НСтр("ru='Обновление выполнено успешно.';uk='Оновлення виконане успішно.'");
	Иначе
		Текст = НСтр("ru='Обновление не требуется.';uk='Оновлення не потрібно.'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокТаблица.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Таблица");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Для всех таблиц, кроме указанных';uk='Для всіх таблиць, крім зазначених'"));

КонецПроцедуры

&НаСервере
Процедура ОбновитьВспомогательныеДанныеРегистраНаСервере(ЕстьИзменения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.НастройкиПравОбъектов.ОбновитьВспомогательныеДанныеРегистра(ЕстьИзменения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
