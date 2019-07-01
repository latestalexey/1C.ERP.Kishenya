
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
		Если Параметры.Свойство("ПоказыватьНеиспользуемыеШаблоныДокументов") Тогда
			ПоказыватьНеиспользуемыеШаблоныДокументов = Параметры.ПоказыватьНеиспользуемыеШаблоныДокументов;
		КонецЕсли;
		Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
			ПоказыватьНеиспользуемыеШаблоныДокументов = Параметры.ТекущаяСтрока.НеИспользуется;
		КонецЕсли;
	Иначе
		Если Параметры.Свойство("ПоказыватьНеиспользуемыеШаблоныДокументов") Тогда
			ПоказыватьНеиспользуемыеШаблоныДокументов = Параметры.ПоказыватьНеиспользуемыеШаблоныДокументов;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "НеИспользуется", ПоказыватьНеиспользуемыеШаблоныДокументов,,, Не ПоказыватьНеиспользуемыеШаблоныДокументов,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", , , , "Организация, НеИспользуется");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ОбновитьИнтерфейс();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьНеиспользуемыеШаблоныДокументовПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "НеИспользуется",, ПоказыватьНеиспользуемыеШаблоныДокументов,,
		Не ПоказыватьНеиспользуемыеШаблоныДокументов, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти
