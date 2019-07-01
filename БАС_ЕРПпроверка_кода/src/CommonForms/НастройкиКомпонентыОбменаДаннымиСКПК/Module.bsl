
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСтатусы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьКомпоненту(Команда)
	
	НачатьУстановкуВнешнейКомпоненты(Неопределено, "ОбщийМакет.КомпонентаОбменДаннымиСМобильнымиПриложениями");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпоненту(Команда)
	
	Если глКомпонентаОбменаСМобильнымиПриложениями <> Неопределено Тогда
		ТекстСообщения = НСтр("ru='Компонента обмена данными с мобильными приложениями уже подключена';uk='Компонента обміну даними з мобільними додатками вже підключена'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		МобильныеПриложенияКлиент.ПодключитьВнешнююКомпонентуДляОбменаДаннымиСМобильнымиПриложениями();
	КонецЕсли;
	
	ОбновитьСтатусы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьКомпоненту(Команда)
	
	Если глКомпонентаОбменаСМобильнымиПриложениями = Неопределено Тогда
		ТекстСообщения = НСтр("ru='Компонента обмена данными не подключена';uk='Компонента обміну даними не підключена'");
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ОтключитьКомпонентуЗавершение", ЭтотОбъект, Новый Структура("ТекстСообщения", ТекстСообщения)), ТекстСообщения);
        Возврат;
	Иначе
		глКомпонентаОбменаСМобильнымиПриложениями.Отключить(0);
		глКомпонентаОбменаСМобильнымиПриложениями = Неопределено;
		ТекстСообщения = НСтр("ru='Отключение компоненты';uk='Відключення компоненти'");
		ТекстПояснения = НСтр("ru='Компонента обмена данными отключена';uk='Компонента обміну даними відключена'");
		ПоказатьОповещениеПользователя(ТекстСообщения,,ТекстПояснения, БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ОтключитьКомпонентуФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьКомпонентуЗавершение(ДополнительныеПараметры) Экспорт
    
    ТекстСообщения = ДополнительныеПараметры.ТекстСообщения;
    
    
    ОтключитьКомпонентуФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ОтключитьКомпонентуФрагмент()
    
    ОбновитьСтатусы();

КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПерсональныеНастройкиРаботыСКомпонентойОбменаДанными",,,,,, Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ОбновитьСтатусы();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОСтатусе(Команда)
	
	ОбновитьСтатусы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусПодключения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомпонентаПОдключена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.SpecialTextColor);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусПодключения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомпонентаПодключена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(51, 153, 102));

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусы()
	
	Если глКомпонентаОбменаСМобильнымиПриложениями <> Неопределено Тогда
		
		КомпонентаПодключена = Истина;
		СтатусПодключения = НСтр("ru='Компонента подключена';uk='Компонента підключена'");
		
		TCPIPПодключен = глКомпонентаОбменаСМобильнымиПриложениями.TCPIPПодключен;
		COMПортПодключен = глКомпонентаОбменаСМобильнымиПриложениями.COMПортПодключен;
		IRDAПодключен = глКомпонентаОбменаСМобильнымиПриложениями.IRDAПодключен;
		
		ПортTCPIP = глКомпонентаОбменаСМобильнымиПриложениями.ПортTCPIP;
		COMПорт = глКомпонентаОбменаСМобильнымиПриложениями.COMПорт;
		ИмяСервисаIRDA = глКомпонентаОбменаСМобильнымиПриложениями.ИмяСервисаIRDA;
		
		ВестиЖурналСобытий = глКомпонентаОбменаСМобильнымиПриложениями.ВестиЖурналСобытий;
		КаталогЖурналаСобытий = глКомпонентаОбменаСМобильнымиПриложениями.КаталогЖурналаСобытий;
		
	Иначе
		
		КомпонентаПодключена = Ложь;
		СтатусПодключения = НСтр("ru='Компонента не подключена';uk='Компонента не підключена'");
		
		TCPIPПодключен = Ложь;
		COMПортПодключен = Ложь;
		IRDAПодключен = Ложь;
		
		ПортTCPIP = 0;
		COMПорт=0;
		ИмяСервисаIRDA = "";
		
		ВестиЖурналСобытий = Ложь;
		КаталогЖурналаСобытий = "";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
