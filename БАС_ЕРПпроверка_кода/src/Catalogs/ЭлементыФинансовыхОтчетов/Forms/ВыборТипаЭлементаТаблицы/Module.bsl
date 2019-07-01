
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьДляВводаПлана = Параметры.ИспользоватьДляВводаПлана;
	ОбновитьДеревоНовыхЭлементовВидаБюджета();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаБюджета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаБюджета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БыстрыйПоискНовыхПриИзменении(Элемент)
	
	ОбновитьДеревоНовыхЭлементовВидаБюджета();
	
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаБюджета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаБюджета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискНовыхОчистка(Элемент, СтандартнаяОбработка)
	
	ОбновитьДеревоНовыхЭлементовВидаБюджета();
	
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаБюджета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаБюджета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ЭлементыВидаБюджетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Выбрать(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиНовыйЭлемент(Команда)
	
	ОбновитьДеревоНовыхЭлементовВидаБюджета();
	
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаБюджета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаБюджета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.ЭлементыВидаБюджета.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ВидЭлемента) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Элемент не может быть выбран!';uk='Елемент не може бути вибраний!'"));
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("ВидЭлемента, 
			|ЭлементОтчета,
			|НаименованиеДляПечати", 
			ТекущиеДанные.ВидЭлемента, 
			ТекущиеДанные.ЭлементВидаОтчетности,
			ТекущиеДанные.Наименование));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере 
Процедура ОбновитьДеревоНовыхЭлементовВидаБюджета()
	
	ПараметрыДерева = Новый Структура("ИмяЭлементаДерева, БыстрыйПоиск, 
									  |РежимДерева, ИспользоватьДляВводаПлана");
	
	ПараметрыДерева.ИмяЭлементаДерева = "ДеревоНовыхЭлементов";
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискНовых;
	ПараметрыДерева.ИспользоватьДляВводаПлана = ИспользоватьДляВводаПлана;
	ПараметрыДерева.РежимДерева = Перечисления.РежимыОтображенияДереваНовыхЭлементов.ВыборВидаЯчейкиСложнойТаблицы;
	
	БюджетнаяОтчетностьВызовСервера.ОбновитьДеревоНовыхЭлементов(ЭтаФорма, ПараметрыДерева);
	
КонецПроцедуры

#КонецОбласти
