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
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
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
	
	// Дополнительные команды
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ПланПроизводства", Параметры.ПараметрКоманды);
	КонецЕсли;
	
	Если Параметры.Свойство("Расшифровка")
		И Параметры.Расшифровка <> Неопределено Тогда
		
		ЗаменятьВариант = Ложь;
		
		Если Параметры.Расшифровка.ПрименяемыеНастройки.Структура.Количество() > 0 Тогда
			
			ПолеНоменклатураПродукции = Новый ПолеКомпоновкиДанных("НоменклатураПродукции");
			ПолеХарактеристикаПродукции = Новый ПолеКомпоновкиДанных("ХарактеристикаПродукции");
			ПолеСпецификация = Новый ПолеКомпоновкиДанных("Спецификация");
			
			Для каждого Группировка Из Параметры.Расшифровка.ПрименяемыеНастройки.Структура[0].ПоляГруппировки.Элементы Цикл
			
				Если Группировка.Поле = ПолеНоменклатураПродукции 
					ИЛИ Группировка.Поле = ПолеХарактеристикаПродукции
					ИЛИ Группировка.Поле = ПолеСпецификация Тогда
				
					ЗаменятьВариант = Истина;
					Прервать;
				
				КонецЕсли; 
			
			КонецЦикла; 
		
		КонецЕсли; 
		
		// заполняем параметры расшифровки
		Если ЭтоАдресВременногоХранилища(Параметры.Расшифровка.Данные) Тогда
		
			ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Параметры.Расшифровка.Данные);
			
			Если НЕ ДанныеРасшифровки.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта")
				ИЛИ ДанныеРасшифровки.Настройки.ДополнительныеСвойства.КлючТекущегоВарианта <> "ПлановаяПотребностьВМатериалахКонтекст" Тогда
			
				Возврат;
			
			КонецЕсли; 
		КонецЕсли; 
		
		Если НЕ ЗаменятьВариант Тогда
			Возврат;
		КонецЕсли; 
		
		Если Параметры.Свойство("КлючВарианта") Тогда
			Параметры.КлючВарианта = "РасшифровкаКонтекст";
		КонецЕсли; 
		Если Параметры.Свойство("КлючНазначенияИспользования") Тогда
			Параметры.КлючНазначенияИспользования = "РасшифровкаКонтекст";
		КонецЕсли;
		
		ЭтаФорма.КлючТекущегоВарианта = "РасшифровкаКонтекст";
		
		ЭтаФорма.РежимВариантаОтчета = Истина;
		ЭтаФорма.РежимРасшифровки = Ложь;
		ЭтаФорма.НастройкиОтчета.РазрешеноМенятьВарианты = Ложь;
		ЭтаФорма.НастройкиОтчета.ВариантСсылка = ВариантыОтчетов.ПолучитьСсылку(ЭтаФорма.НастройкиОтчета.ОтчетСсылка, ЭтаФорма.КлючТекущегоВарианта);
		
	КонецЕсли;
	

КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта") 
		И КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.КлючТекущегоВарианта = "ПлановаяПотребностьВМатериалахКонтекст"
		И ЭтаФорма.КлючТекущегоВарианта = "РасшифровкаКонтекст" Тогда
		
		Сценарий = Неопределено;
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("Сценарий", Сценарий);
		
		ОтчетОбъект = Отчеты.ПлановаяПотребностьВМатериалах.Создать();
		Вариант = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(ЭтаФорма.КлючТекущегоВарианта);
		
		КомпоновкаДанныхКлиентСервер.ЗаполнитьЭлементы(Вариант.Настройки.ПараметрыДанных,	КомпоновщикНастроекФормы.Настройки.ПараметрыДанных);
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(Вариант.Настройки.Отбор,			КомпоновщикНастроекФормы.Настройки.Отбор, Ложь);
		
		КомпоновщикНастроекФормы.ЗагрузитьНастройки(Вариант.Настройки);
		
		Если Сценарий <> Неопределено Тогда
		
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
				КомпоновщикНастроекФормы, 
				"Сценарий", 
				Сценарий);
		
		КонецЕсли;
		
	КонецЕсли; 
	
	КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	
	Если ЭтаФорма.ФормаПараметры.Отбор.Свойство("ПланПроизводства") Тогда
	
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить(
			"Сценарий", 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтаФорма.ФормаПараметры.Отбор.ПланПроизводства, "Сценарий"));
		
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроекФормы, 
			"Сценарий", 
			КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Сценарий);

	
	КонецЕсли; 
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

#КонецОбласти

#КонецЕсли