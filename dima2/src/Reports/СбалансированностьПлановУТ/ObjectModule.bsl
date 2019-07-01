#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПередЗаполнениемПанелиБыстрыхНастроек = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	Планирование.СбалансированностьПлановПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Вызывается до перезаполнения панели настроек формы отчета.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   ПараметрыЗаполнения - Структура - Параметры, которые будут загружены в отчет.
//
Процедура ПередЗаполнениемПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
	Если ПараметрыЗаполнения.ИмяСобытия = "ПриОбновленииСоставаПользовательскихНастроекНаСервере" Тогда
		
		Планирование.СбалансированностьПлановПередЗагрузкойПользовательскихНастроекНаСервере(Форма, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	Планирование.СбалансированностьПлановПриКомпоновкеРезультата(КомпоновщикНастроек, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли