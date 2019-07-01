#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Получаем виртуальную таблицу Представления_КадровыеДанныеСотрудников.
	ИнициализироватьОтчет();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	МассивСотрудников = Неопределено;
	Для каждого ЭлементОтбора Из НастройкиОтчета.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник")
			И ЭлементОтбора.Использование Тогда
			
			МассивСотрудников = Новый Массив;
			МассивСотрудников.Добавить(ЭлементОтбора.ПравоеЗначение);
			
		КонецЕсли;
	КонецЦикла; 
	
	ДатаОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ДатаОтчета");
	Если НЕ ДатаОтчета.Использование Тогда
		ДатаОтчета.Значение = Новый СтандартнаяДатаНачала(ВариантСтандартнойДатыНачала.НачалоЭтогоДня);
		ДатаОтчета.Использование = Истина;
	КонецЕсли;
	
	// Заполняем регистр ЗаработанныеПраваНаОтпуска.
    ОстаткиОтпусков.РасчетЗаработанныхОтпусков(МассивСотрудников, ДатаОтчета.Значение.Дата);
	
	СтандартнаяОбработка = ложь;
	
	ДокументРезультат.Очистить();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	// Создадим и инициализируем процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Обозначим начало вывода.
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
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
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли