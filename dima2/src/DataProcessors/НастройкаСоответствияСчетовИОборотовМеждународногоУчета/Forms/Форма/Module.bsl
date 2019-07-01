
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("УчетнаяПолитика") Тогда
		УчетнаяПолитика = Параметры.УчетнаяПолитика;
	КонецЕсли;
	
	Если Параметры.Свойство("СчетРеглУчета") Тогда
		СчетРеглУчета = Параметры.СчетРеглУчета;
		Если ТипЗнч(СчетРеглУчета) = Тип("ПланСчетовСсылка.Хозрасчетный") Тогда
			Элементы.ПланСчетовРеглУчета.ТекущаяСтрока = СчетРеглУчета;
		КонецЕсли;    
	КонецЕсли;
	
	УстановитьПараметрУчетнаяПолитика();
	УстановитьОтборПоСчетуРеглУчета();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(УчетнаяПолитика) Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьПараметрУчетнаяПолитика();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьСоответствияСчетов"
			Или ИмяСобытия = "ЗаписьСоответствияОборотов"
			Или ИмяСобытия = "ИзмененыНастройкиИспользованияВУчетнойПолитике" Тогда
			
		ОбработатьОповещениеСервер(ИмяСобытия, Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьОповещениеСервер(ИмяСобытия, Источник) 
	
	Если ИмяСобытия = "ЗаписьСоответствияСчетов"
		Или (ИмяСобытия = "ИзмененыНастройкиИспользованияВУчетнойПолитике" 
			И ТипЗнч(Источник) = Тип("СправочникСсылка.СоответствияСчетовМеждународногоУчета")) Тогда
		Элементы.ПланСчетовРеглУчета.Обновить();
		Элементы.СоответствияСчетовМеждународногоУчета.Обновить();
		Элементы.ПланСчетовМеждународногоУчета.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьСоответствияОборотов"
		Или (ИмяСобытия = "ИзмененыНастройкиИспользованияВУчетнойПолитике" 
			И ТипЗнч(Источник) = Тип("СправочникСсылка.СоответствияОборотовМеждународногоУчета")) Тогда
		Элементы.ПланСчетовМеждународногоУчета.Обновить();
		Элементы.СоответствияОборотовМеждународногоУчета.Обновить();
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ПланСчетовМеждународногоУчета.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ЗаполнитьНастройкиПоСчетуМеждународногоУчета(ТекущаяСтрока);
	КонецЕсли;
		
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УчетнаяПолитикаПриИзменении(Элемент)
	
	УстановитьПараметрУчетнаяПолитика();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСчетовРеглУчетаПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовРеглУчетаПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСчетовМеждународногоУчетаПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикПланСчетовМеждународногоУчетаПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланСчетовМеждународногоУчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
	ПараметрыФормы.Вставить("ОтображатьПризнакРекласс", Истина);
	
	ОткрытьФорму("ПланСчетов.Международный.Форма.ФормаСчета", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствияСчетовМеждународногоУчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(ТекущийСчетРеглУчета) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Для добавления соответствия выберете счет';uk='Для додавання відповідності виберіть рахунок'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ПланСчетовРеглУчета.ДанныеСтроки(ТекущийСчетРеглУчета).ЗапретитьИспользоватьВПроводках Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Для добавления соответствия выберете счет, который используется в проводках';uk='Для додавання відповідності виберіть рахунок, який використовується в проводках'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УчетнаяПолитика) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяПолитика", УчетнаяПолитика);
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	Иначе
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("СчетРеглУчета", ТекущийСчетРеглУчета);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СоответствияСчетовМеждународногоУчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНастроекПоСчетуМеждународногоУчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоНастроекПоСчетуМеждународногоУчета.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ПараметрыФормы = Новый Структура;
	Если ЗначениеЗаполнено(ТекущиеДанные.СоответствиеОборотов) Тогда
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.СоответствиеОборотов);
		ОткрытьФорму("Справочник.СоответствияОборотовМеждународногоУчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.СоответствиеСчетов) Тогда
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.СоответствиеСчетов);
		ОткрытьФорму("Справочник.СоответствияСчетовМеждународногоУчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетовРеглУчетаПриИзменении(Элемент)
	
	ПриИзмененииОтбораСчетовСервер("ПланСчетовРеглУчета", ОтборСчетовРеглУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетовМеждународногоУчетаПриИзменении(Элемент)
	
	ПриИзмененииОтбораСчетовСервер("ПланСчетовМеждународногоУчета", ОтборСчетовМеждународногоУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствияОборотовМеждународногоУчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(УчетнаяПолитика) Или Группа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяПолитика", УчетнаяПолитика);
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СоответствияОборотовМеждународногоУчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ВключитьСчетВИгнорируемыеПриОтраженииВМеждународномУчете(Команда)
	
	СчетаРеглУчета = Элементы.ПланСчетовРеглУчета.ВыделенныеСтроки;
	Если СчетаРеглУчета.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьИгнорированиеСчетаПриОтраженииВМеждународномУчетеСервер(СчетаРеглУчета, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСчетИзИгнорируемыхПриОтраженииВМеждународномУчете(Команда)
	
	СчетаРеглУчета = Элементы.ПланСчетовРеглУчета.ВыделенныеСтроки;
	Если СчетаРеглУчета.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьИгнорированиеСчетаПриОтраженииВМеждународномУчетеСервер(СчетаРеглУчета, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСчетовПереместитьВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(
		СоответствияСчетовМеждународногоУчета, Элементы.СоответствияСчетовМеждународногоУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСчетовПереместитьВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(
		СоответствияСчетовМеждународногоУчета, Элементы.СоответствияСчетовМеждународногоУчета);

КонецПроцедуры

&НаКлиенте
Процедура СоответствиеОборотовПереместитьВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(
		СоответствияОборотовМеждународногоУчета, Элементы.СоответствияОборотовМеждународногоУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеОборотовПереместитьВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(
		СоответствияОборотовМеждународногоУчета, Элементы.СоответствияОборотовМеждународногоУчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьСоответствиеСчетовВУчетнуюПолитику(Команда)
	
	МассивСоотвествий = Элементы.СоответствияСчетовМеждународногоУчета.ВыделенныеСтроки;
	Если МассивСоотвествий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СпискиДляОбновления = Новый Массив;
	СпискиДляОбновления.Добавить("ПланСчетовРеглУчета");
	СпискиДляОбновления.Добавить("СоответствияСчетовМеждународногоУчета");
	СпискиДляОбновления.Добавить("ПланСчетовМеждународногоУчета");
	
	ИзменитьВключениеВУчетнуюПолитикуНаСервере(МассивСоотвествий, Истина, СпискиДляОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьСоответствиеОборотовВУчетнуюПолитику(Команда)
	
	ВыбранныеСтроки = Элементы.СоответствияОборотовМеждународногоУчета.ВыделенныеСтроки;
	
	Соответствия = Новый Массив;
	Для каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		ДанныеСтроки = Элементы.СоответствияОборотовМеждународногоУчета.ДанныеСтроки(ВыбраннаяСтрока);
		Если Не ДанныеСтроки.ЭтоГруппа Тогда
			Соответствия.Добавить(ВыбраннаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если Соответствия.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СпискиДляОбновления = Новый Массив;
	СпискиДляОбновления.Добавить("СоответствияОборотовМеждународногоУчета");
	СпискиДляОбновления.Добавить("ПланСчетовМеждународногоУчета");
	
	ИзменитьВключениеВУчетнуюПолитикуНаСервере(Соответствия, Истина, СпискиДляОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСоответствиеСчетовИзУчетнойПолитики(Команда)
	
	ВыбранныеСтроки = Элементы.СоответствияСчетовМеждународногоУчета.ВыделенныеСтроки;
	Если ВыбранныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СпискиДляОбновления = Новый Массив;
	СпискиДляОбновления.Добавить("ПланСчетовРеглУчета");
	СпискиДляОбновления.Добавить("СоответствияСчетовМеждународногоУчета");
	СпискиДляОбновления.Добавить("ПланСчетовМеждународногоУчета");
	
	ИзменитьВключениеВУчетнуюПолитикуНаСервере(ВыбранныеСтроки, Ложь, СпискиДляОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСоответствиеОборотовИзУчетнойПолитики(Команда)
	
	ВыбранныеСтроки = Элементы.СоответствияОборотовМеждународногоУчета.ВыделенныеСтроки;
	
	Соответствия = Новый Массив;
	Для каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		ДанныеСтроки = Элементы.СоответствияОборотовМеждународногоУчета.ДанныеСтроки(ВыбраннаяСтрока);
		Если Не ДанныеСтроки.ЭтоГруппа Тогда
			Соответствия.Добавить(ВыбраннаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если Соответствия.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СпискиДляОбновления = Новый Массив;
	СпискиДляОбновления.Добавить("СоответствияОборотовМеждународногоУчета");
	СпискиДляОбновления.Добавить("ПланСчетовМеждународногоУчета");
	
	ИзменитьВключениеВУчетнуюПолитикуНаСервере(Соответствия, Ложь, СпискиДляОбновления);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСоответствиеПоСчету(Команда)
	
	ТекущиеДанные = Элементы.ДеревоНастроекПоСчетуМеждународногоУчета.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено 
		Или (Не ЗначениеЗаполнено(ТекущиеДанные.СоответствиеОборотов) 
				И Не ЗначениеЗаполнено(ТекущиеДанные.СоответствиеСчетов)) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не выбрано соответствие счетов или оборотов';uk='Не вибрано відповідність рахунків або оборотів'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если ЗначениеЗаполнено(ТекущиеДанные.СоответствиеОборотов) Тогда
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.СоответствиеОборотов);
		ОткрытьФорму("Справочник.СоответствияОборотовМеждународногоУчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.СоответствиеСчетов) Тогда
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.СоответствиеСчетов);
		ОткрытьФорму("Справочник.СоответствияСчетовМеждународногоУчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаСервере
Функция ПроверитьЗаполнениеУчетнойПолитики()
	
	Результат = ЗначениеЗаполнено(УчетнаяПолитика);
	
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено поле ""Учетная политика""';uk='Не заповнено поле ""Облікова політика""'"), ,"УчетнаяПолитика");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление() 
	
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПланСчетовРеглУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПланСчетовРеглУчета.ИгнорируетсяПриОтраженииВМеждународномУчете");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияСчетовМеждународногоУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияСчетовМеждународногоУчета.ДействуетВУчетнойПолитике");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ДействуетВУчетнойПолитике");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоНастроекПоСчетуМеждународногоУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоНастроекПоСчетуМеждународногоУчета.ДействуетВУчетнойПолитике");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоНастроекПоСчетуМеждународногоУчета.ГруппаНастроек");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияСчетовМеждународногоУчетаПредставлениеОтбора.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияСчетовМеждународногоУчета.ПредставлениеОтбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<без отбора>';uk='<без відбору>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаПредставлениеОтбора.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ПредставлениеОтбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<без отбора>';uk='<без відбору>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаВариантСовместногоПрименения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаСчетРеглУчетаДт.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаНаименованиеСчетРеглУчетаДт.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаСчетРеглУчетаКт.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаНаименованиеСчетРеглУчетаКт.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаВариантСовместногоПрименения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ВариантСовместногоПрименения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыСовместногоПримененияШаблоновПроводок.Вытеснение;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Только первое подходящее по условиям отбора соответствие группы';uk='Тільки перша підходяща за умовами відбору відповідність групи'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияОборотовМеждународногоУчетаВариантСовместногоПрименения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ЭтоГруппа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияОборотовМеждународногоУчета.ВариантСовместногоПрименения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыСовместногоПримененияШаблоновПроводок.Все;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Все соответствия группы';uk='Всі відповідності групи'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрУчетнаяПолитика()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СоответствияОборотовМеждународногоУчета, "УчетнаяПолитика", УчетнаяПолитика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СоответствияСчетовМеждународногоУчета, "УчетнаяПолитика", УчетнаяПолитика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ПланСчетовРеглУчета, "УчетнаяПолитика", УчетнаяПолитика, Истина);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСчетуРеглУчета()
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СоответствияСчетовМеждународногоУчета, "СчетРеглУчета", ТекущийСчетРеглУчета, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПланСчетовРеглУчетаПриАктивизацииСтроки()
	
	ТекущийСчетРеглУчета = Элементы.ПланСчетовРеглУчета.ТекущаяСтрока;
	УстановитьОтборПоСчетуРеглУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПланСчетовМеждународногоУчетаПриАктивизацииСтроки()
	
	ЗаполнитьНастройкиПоСчетуМеждународногоУчета(Элементы.ПланСчетовМеждународногоУчета.ТекущаяСтрока);
	МеждународныйУчетКлиентСервер.РазвернутьДерево(
		ЭтаФорма, "ДеревоНастроекПоСчетуМеждународногоУчета", ДеревоНастроекПоСчетуМеждународногоУчета, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИгнорированиеСчетаПриОтраженииВМеждународномУчетеСервер(СчетаРеглУчета, Игнорировать)
	
	Если Не ПроверитьЗаполнениеУчетнойПолитики() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписейИгнорируемыеСчета = РегистрыСведений.СчетаРеглУчетаИгнорируемыеПриОтраженииВМеждународномУчете.СоздатьНаборЗаписей();
	НаборЗаписейИгнорируемыеСчета.Отбор.УчетнаяПолитика.Установить(УчетнаяПолитика);
	НаборЗаписейИгнорируемыеСчета.Прочитать();
	ТаблицаЗаписей = НаборЗаписейИгнорируемыеСчета.Выгрузить();
	
	НаборЗаписейПравилаОтражения = РегистрыСведений.ПравилаОтраженияВМеждународномУчете.СоздатьНаборЗаписей();
	НаборЗаписейПравилаОтражения.Отбор.УчетнаяПолитика.Установить(УчетнаяПолитика);
	НаборЗаписейПравилаОтражения.Прочитать();
	ТаблицаПравилОтражения = НаборЗаписейПравилаОтражения.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоответствияСчетов.Ссылка КАК Ссылка,
	|	СоответствияСчетов.СчетРеглУчета КАК СчетРеглУчета 
	|ИЗ
	|	Справочник.СоответствияСчетовМеждународногоУчета КАК СоответствияСчетов
	|ГДЕ
	|	СоответствияСчетов.СчетРеглУчета В (&СчетаРеглУчета)";
	Запрос.УстановитьПараметр("СчетаРеглУчета", СчетаРеглУчета);
	ТаблицаСоответствийСчетов = Запрос.Выполнить().Выгрузить();
	ТаблицаСоответствийСчетов.Индексы.Добавить("СчетРеглУчета");
	
	Для каждого СчетРеглУчета Из СчетаРеглУчета Цикл
		Запись = ТаблицаЗаписей.Найти(СчетРеглУчета, "СчетРеглУчета");
		Если Запись = Неопределено И Игнорировать Тогда
			НоваяСтрока = ТаблицаЗаписей.Добавить();
			НоваяСтрока.УчетнаяПолитика = УчетнаяПолитика;
			НоваяСтрока.СчетРеглУчета = СчетРеглУчета;
			
			ОтборПоСчету = Новый Структура("СчетРеглУчета", СчетРеглУчета);
			СоответствияСчетов = ТаблицаСоответствийСчетов.НайтиСтроки(ОтборПоСчету);
			Для каждого СоответствиеСчетов Из СоответствияСчетов Цикл
				ЗаписьПоСоответствиюСчетов = ТаблицаПравилОтражения.Найти(СоответствиеСчетов.Ссылка, "ШаблонПроводки");
				Если ЗаписьПоСоответствиюСчетов <> Неопределено Тогда
					ТаблицаПравилОтражения.Удалить(ЗаписьПоСоответствиюСчетов);
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли Запись <> Неопределено И Не Игнорировать Тогда
			ТаблицаЗаписей.Удалить(Запись);
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписейИгнорируемыеСчета.Загрузить(ТаблицаЗаписей);
	НаборЗаписейПравилаОтражения.Загрузить(ТаблицаПравилОтражения);
	
	НачатьТранзакцию();
	Попытка
		НаборЗаписейПравилаОтражения.Записать();
		НаборЗаписейИгнорируемыеСчета.Записать();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	ЗафиксироватьТранзакцию();
	
	Элементы.СоответствияСчетовМеждународногоУчета.Обновить();
	Элементы.ПланСчетовРеглУчета.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиПоСчетуМеждународногоУчета(СчетМеждународногоУчета)
	
	ДеревоНастроекПоСчетуМеждународногоУчета.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоответствияСчетов.Ссылка КАК СоответствиеСчетов,
	|	СоответствияСчетов.СчетРеглУчета КАК СчетРеглУчета,
	|	СоответствияСчетов.ПредставлениеОтбора КАК ПредставлениеОтбора,
	|	СоответствияСчетов.УстановленДополнительныйОтбор КАК УстановленДополнительныйОтбор,
	|	ВЫБОР
	|		КОГДА ПравилаОтражения.ШаблонПроводки ЕСТЬ НЕ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДействуетВУчетнойПолитике
	|ИЗ
	|	Справочник.СоответствияСчетовМеждународногоУчета КАК СоответствияСчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПравилаОтраженияВМеждународномУчете КАК ПравилаОтражения
	|		ПО (ПравилаОтражения.УчетнаяПолитика = &УчетнаяПолитика)
	|			И СоответствияСчетов.Ссылка = ПравилаОтражения.ШаблонПроводки
	|ГДЕ
	|	СоответствияСчетов.СчетМеждународногоУчета = &СчетМеждународногоУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответсвиеОборотов.Ссылка КАК СоответствиеОборотов,
	|	СоответсвиеОборотов.СчетРеглУчетаДт,
	|	СоответсвиеОборотов.СчетРеглУчетаКт,
	|	СоответсвиеОборотов.ПредставлениеОтбора,
	|	СоответсвиеОборотов.УстановленДополнительныйОтбор,
	|	СоответсвиеОборотов.РучноеУточнениеПроводки,
	|	ВЫБОР
	|		КОГДА СоответсвиеОборотов.СчетМеждународногоУчетаДт = &СчетМеждународногоУчета
	|				И СоответсвиеОборотов.СчетМеждународногоУчетаКт = &СчетМеждународногоУчета
	|			ТОГДА &ДтКт
	|		КОГДА СоответсвиеОборотов.СчетМеждународногоУчетаДт = &СчетМеждународногоУчета
	|			ТОГДА &Дт
	|		ИНАЧЕ &Кт
	|	КОНЕЦ КАК ПоложениеСчета,
	|	ВЫБОР
	|		КОГДА ПравилаОтражения.ШаблонПроводки ЕСТЬ НЕ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДействуетВУчетнойПолитике
	|ИЗ
	|	Справочник.СоответствияОборотовМеждународногоУчета КАК СоответсвиеОборотов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПравилаОтраженияВМеждународномУчете КАК ПравилаОтражения
	|		ПО (ПравилаОтражения.УчетнаяПолитика = &УчетнаяПолитика)
	|			И СоответсвиеОборотов.Ссылка = ПравилаОтражения.ШаблонПроводки
	|ГДЕ
	|	(СоответсвиеОборотов.СчетМеждународногоУчетаДт = &СчетМеждународногоУчета
	|			ИЛИ СоответсвиеОборотов.СчетМеждународногоУчетаКт = &СчетМеждународногоУчета)";
	
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	Запрос.УстановитьПараметр("СчетМеждународногоУчета", СчетМеждународногоУчета);
	Запрос.УстановитьПараметр("ДтКт", НСтр("ru='Дт/Кт';uk='Дт/Кт'"));
	Запрос.УстановитьПараметр("Дт", НСтр("ru='Дт';uk='Дт'"));
	Запрос.УстановитьПараметр("Кт", НСтр("ru='Кт';uk='Кт'"));
	
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	ВыборкаШаблоныПроводок = РезультатыЗапросов[1].Выбрать();
	Если ВыборкаШаблоныПроводок.Количество() Тогда
		ЭлементШаблоныПроводок = ДеревоНастроекПоСчетуМеждународногоУчета.ПолучитьЭлементы().Добавить();
		ЭлементШаблоныПроводок.ГруппаНастроек = НСтр("ru='Соответствия оборотов';uk='Відповідності оборотів'");
		ЭлементыШаблоныПроводок = ЭлементШаблоныПроводок.ПолучитьЭлементы();
		Пока ВыборкаШаблоныПроводок.Следующий() Цикл
			НовыйЭлемент = ЭлементыШаблоныПроводок.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ВыборкаШаблоныПроводок);
		КонецЦикла;
	КонецЕсли;
	
	ВыборкаСоответствияСчетов = РезультатыЗапросов[0].Выбрать();
	Если ВыборкаСоответствияСчетов.Количество() Тогда
		ЭлементСоответствиеСчетов = ДеревоНастроекПоСчетуМеждународногоУчета.ПолучитьЭлементы().Добавить();
		ЭлементСоответствиеСчетов.ГруппаНастроек = НСтр("ru='Соответствия счетов';uk='Відповідності рахунків'");
		ЭлементыСоответствиеСчетов = ЭлементСоответствиеСчетов.ПолучитьЭлементы();
		Пока ВыборкаСоответствияСчетов.Следующий() Цикл
			НовыйЭлемент = ЭлементыСоответствиеСчетов.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ВыборкаСоответствияСчетов);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВключениеВУчетнуюПолитикуНаСервере(Соответствия, ВключитьВУчетнуюПолитику, СпискиДляОбновления)
	
	Если Не ПроверитьЗаполнениеУчетнойПолитики() Тогда
		Возврат;
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.ПравилаОтраженияВМеждународномУчете.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяПолитика.Установить(УчетнаяПолитика);
	
	НаборЗаписей.Прочитать();
	ТаблицаЗаписей = НаборЗаписей.Выгрузить();
	
	Для каждого Соответствие Из Соответствия Цикл
		
		Запись = ТаблицаЗаписей.Найти(Соответствие, "ШаблонПроводки");
		Если Запись = Неопределено И ВключитьВУчетнуюПолитику Тогда
			НоваяСтрока = ТаблицаЗаписей.Добавить();
			НоваяСтрока.УчетнаяПолитика = УчетнаяПолитика;
			НоваяСтрока.ШаблонПроводки = Соответствие;
		ИначеЕсли Запись <> Неопределено И Не ВключитьВУчетнуюПолитику Тогда
			ТаблицаЗаписей.Удалить(Запись);
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.Загрузить(ТаблицаЗаписей);
	НаборЗаписей.Записать();
	
	Для каждого Список Из СпискиДляОбновления Цикл
		Элементы[Список].Обновить();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтбораСчетовСервер(СписокСчетов, ЗначениеОтбора)
	
	ПравоеЗначение = ?(ЗначениеОтбора = "СНастроеннымСоответствием", Истина, Ложь);
	УстановитьОтбор =  ЗначениеОтбора <> "";
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		ЭтаФорма[СписокСчетов], "НастроеноСоответствие", ПравоеЗначение, УстановитьОтбор);
		
	Если УстановитьОтбор Тогда
		Элементы[СписокСчетов].Отображение = ОтображениеТаблицы.Список;
	Иначе
		Элементы[СписокСчетов].Отображение = ОтображениеТаблицы.Дерево;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти




