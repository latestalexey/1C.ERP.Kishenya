#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	Параметры = ЭтаФорма.Параметры;
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	Если НЕ (Параметры.Свойство("Расшифровка") И Параметры.Расшифровка = Неопределено) Тогда
		ПараметрыРасшифровки = Параметры.Расшифровка;
		ПрименяемыеНастройки = КомпоновщикНастроекФормы.ФиксированныеНастройки;
		
		// Установить параметры данных
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ТекущийПериод", ПараметрыРасшифровки.ТекущийПериод);
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ПрошлыйПериод", ПараметрыРасшифровки.ПрошлыйПериод);
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ТипПараметраКлассификации", ПараметрыРасшифровки.ТипПараметраКлассификации);
			
		// Установить отбор
		ОтборРасшифровки = ПрименяемыеНастройки.Отбор;
		Для Каждого Элемент Из ПараметрыРасшифровки.Отбор Цикл
			ЭлементОтбора = ОтборРасшифровки.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элемент.Ключ);
			ЭлементОтбора.ПравоеЗначение = Элемент.Значение;
			ЭлементОтбора.Использование  = Истина;
		КонецЦикла;
		
		ПараметрыРасшифровки.Вставить("ПрименяемыеНастройки", ПрименяемыеНастройки);
	КонецЕсли;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	Параметры = ЭтаФорма.НастройкиОтчета;

	Если Параметры.Свойство("Расшифровка") И Параметры.Расшифровка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Установить заголовки
	ПараметрыРасшифровки = Параметры.Расшифровка;
	Настройки = Отчет.КомпоновщикНастроек.Настройки;
	Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("Заголовок", ПараметрыРасшифровки.Заголовок);
	Выбор = Настройки.Выбор.Элементы;
	ПредыдущееЗначениеПараметра = Новый ПолеКомпоновкиДанных("ПрошлоеЗначениеПараметраКлассификации");
	ТекущееЗначениеПараметра = Новый ПолеКомпоновкиДанных("ТекущееЗначениеПараметраКлассификации");
	Для Каждого Элемент Из Выбор Цикл
		Если Элемент.Поле = ПредыдущееЗначениеПараметра
		 Или Элемент.Поле = ТекущееЗначениеПараметра Тогда
			Элемент.Заголовок = ПараметрыРасшифровки.ТипПараметраКлассификации;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли