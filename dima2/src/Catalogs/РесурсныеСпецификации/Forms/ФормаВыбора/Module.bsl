
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОтборИзделие", ОтборИзделие);
	Параметры.Свойство("ОтборСписокСпецификаций", ОтборСписокСпецификаций);
	Элементы.ОтборСпецификации.Видимость = ОтборСписокСпецификаций;
	
	МассивСпецификаций = Новый Массив;
	Если Параметры.Свойство("МассивСпецификаций", МассивСпецификаций) Тогда
		СписокСпецификаций.ЗагрузитьЗначения(МассивСпецификаций);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НоменклатураИзделие", ОтборИзделие);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НоменклатураМатериал", Справочники.Номенклатура.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтборСписокСпецификаций", ОтборСписокСпецификаций);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "СписокСпецификаций", СписокСпецификаций.ВыгрузитьЗначения());
	
	Элементы.Список.Отображение = ?(ОтборСписокСпецификаций, ОтображениеТаблицы.Список, ОтображениеТаблицы.ИерархическийСписок);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОсновныеСпецификации" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборИзделиеПриИзменении(Элемент)
	
	УстановитьОтборПоИзделию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМатериалПриИзменении(Элемент)
	
	УстановитьОтборПоМатериалу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСписокСпецификацийПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтборСписокСпецификаций", ОтборСписокСпецификаций);
	Элементы.Список.Отображение = ?(ОтборСписокСпецификаций, ОтображениеТаблицы.Список, ОтображениеТаблицы.ИерархическийСписок);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусу(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Статус", 
		Форма.ОтборСтатус, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборСтатус));
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИзделию(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"НоменклатураИзделие", 
		Форма.ОтборИзделие, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборИзделие));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "НоменклатураИзделие", Форма.ОтборИзделие);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоМатериалу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"НоменклатураМатериал", 
		Форма.ОтборМатериал, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборМатериал));

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "НоменклатураМатериал", Форма.ОтборМатериал);
	
КонецПроцедуры

#КонецОбласти

