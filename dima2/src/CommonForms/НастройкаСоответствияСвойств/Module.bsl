#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.ФормаСохранитьНастройку.Доступность = Ложь;
	КонецЕсли; 
	
	СвойстваМатериала = УправлениеДаннымиОбИзделиях.ПолучитьСвойстваДляАвтоподбора(Параметры.ВидМатериала, Истина);
	СвойстваПродукции = УправлениеДаннымиОбИзделиях.ПолучитьСвойстваДляАвтоподбора(Параметры.ВидИзделий);
	Для каждого ДанныеСвойстваМатериала Из СвойстваМатериала Цикл
		Если ДанныеСвойстваМатериала.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = СоответствиеСвойств.Добавить();
		НоваяСтрока.СвойствоМатериала = ДанныеСвойстваМатериала.Свойство;
		НоваяСтрока.СвойствоМатериалаПредставление = ДанныеСвойстваМатериала.Представление;
		
		// Добавим свойства продукции, которые можно сопоставить
		// Свойства можно сопоставить, если
		// - свойства одинаковые
		// - свойства разные, но используется общий список значений
		// - тип свойства примитивный (число, строка, булево, дата)
		Для каждого ДанныеСвойстваПродукции Из СвойстваПродукции Цикл
			Если НЕ ДанныеСвойстваПродукции.ПометкаУдаления
				И (ДанныеСвойстваПродукции.Свойство = ДанныеСвойстваМатериала.Свойство 
					ИЛИ ДанныеСвойстваПродукции.ВладелецДополнительныхЗначений = ДанныеСвойстваМатериала.Свойство
					
					ИЛИ ДанныеСвойстваПродукции.Свойство = ДанныеСвойстваМатериала.ВладелецДополнительныхЗначений
					
					ИЛИ ДанныеСвойстваПродукции.ВладелецДополнительныхЗначений = ДанныеСвойстваМатериала.ВладелецДополнительныхЗначений
						И ЗначениеЗаполнено(ДанныеСвойстваПродукции.ВладелецДополнительныхЗначений)
						
					ИЛИ ДанныеСвойстваПродукции.Свойство.ТипЗначения.Типы().Количество() = 1
						И (ДанныеСвойстваПродукции.Свойство.ТипЗначения.СодержитТип(Тип("Число"))
							 И ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Число"))
							 
							ИЛИ ДанныеСвойстваПродукции.Свойство.ТипЗначения.СодержитТип(Тип("Строка"))
								И ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Строка"))
								
							ИЛИ ДанныеСвойстваПродукции.Свойство.ТипЗначения.СодержитТип(Тип("Булево"))
								И ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Булево"))
								
							ИЛИ ДанныеСвойстваПродукции.Свойство.ТипЗначения.СодержитТип(Тип("Дата"))
								И ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Дата")))) Тогда
					
				НоваяСтрока.СписокДоступныхСвойств.Добавить(ДанныеСвойстваПродукции.Свойство, ДанныеСвойстваПродукции.Представление);
			КонецЕсли; 
		КонецЦикла;
		
		НоваяСтрока.ЕстьДоступныеСвойстваДляВыбора = (НоваяСтрока.СписокДоступныхСвойств.Количество() <> 0);
		
	КонецЦикла;
	
	// Заполним СвойствоПродукции
	Для каждого ТекущиеДанные Из СоответствиеСвойств Цикл
		
		Если ТекущиеДанные.СписокДоступныхСвойств.Количество() > 1 Тогда
			
			СтруктураПоиска = Новый Структура("СвойствоМатериала", ТекущиеДанные.СвойствоМатериала);
			СписокСтрок = Параметры.СоответствиеСвойств.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() <> 0 Тогда
				
				ЭлСвойствоПродукции = ТекущиеДанные.СписокДоступныхСвойств.НайтиПоЗначению(СписокСтрок[0].СвойствоПродукции);
				Если ЭлСвойствоПродукции <> Неопределено Тогда
					ТекущиеДанные.СвойствоПродукции              = СписокСтрок[0].СвойствоПродукции;
					ТекущиеДанные.СвойствоПродукцииПредставление = ЭлСвойствоПродукции.Представление;
				КонецЕсли; 
				
			КонецЕсли;
			
		ИначеЕсли ТекущиеДанные.СписокДоступныхСвойств.Количество() = 1 Тогда
			ТекущиеДанные.СвойствоПродукции              = ТекущиеДанные.СписокДоступныхСвойств[0].Значение;
			ТекущиеДанные.СвойствоПродукцииПредставление = ТекущиеДанные.СписокДоступныхСвойств[0].Представление;
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?';uk='Дані були змінені. Зберегти зміни?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоответствиеСвойств

&НаКлиенте
Процедура СоответствиеСвойствСвойствоПродукцииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	Если НЕ ТекущиеДанные.ЕстьДоступныеСвойстваДляВыбора Тогда
		Возврат
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СвойствоПродукцииНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеОповещения, ТекущиеДанные.СписокДоступныхСвойств, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствСвойствоПродукцииПредставление.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.ЕстьДоступныеСвойстваДляВыбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<нет свойств доступных для выбора>';uk='<немає властивостей доступних для вибору>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

КонецПроцедуры

&НаКлиенте
Процедура СвойствоПродукцииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент <> Неопределено Тогда
		ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
		ТекущиеДанные.СвойствоПродукции = ВыбранныйЭлемент.Значение;
		ТекущиеДанные.СвойствоПродукцииПредставление = ВыбранныйЭлемент.Представление;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()

	СоответствиеСвойствТекущегоМатериала = Новый Массив;
	Для каждого СтрокаСоответствие Из СоответствиеСвойств Цикл
		НастройкаСоответствия = Новый Структура("СвойствоМатериала,СвойствоПродукции", 
												СтрокаСоответствие.СвойствоМатериала, СтрокаСоответствие.СвойствоПродукции);
		СоответствиеСвойствТекущегоМатериала.Добавить(НастройкаСоответствия);
	КонецЦикла; 
	
	Модифицированность = Ложь;
	
	Закрыть(СоответствиеСвойствТекущегоМатериала);

КонецПроцедуры

#КонецОбласти
