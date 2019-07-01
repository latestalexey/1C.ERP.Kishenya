#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует новую учетную запись значениями по умолчанию.
//
Процедура ЗаполнитьОбъектЗначениямиПоУмолчанию() Экспорт
	
	ИмяПользователя = НСтр("ru='BAS ERP';uk='BAS ERP'");
	ИспользоватьДляПолучения = Ложь;
	ИспользоватьДляОтправки = Ложь;
	ОставлятьКопииСообщенийНаСервере = Ложь;
	ПериодХраненияСообщенийНаСервере = 0;
	ВремяОжидания = 30;
	ПортСервераВходящейПочты = 110;
	ПортСервераИсходящейПочты = 25;
	ПротоколВходящейПочты = "POP";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьОбъектЗначениямиПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ИспользоватьДляОтправки И Не ИспользоватьДляПолучения Тогда
		ПроверяемыеРеквизиты.Очистить();
		ПроверяемыеРеквизиты.Добавить("Наименование");
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ИспользоватьДляОтправки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерверИсходящейПочты");
	КонецЕсли;
	
	Если Не ИспользоватьДляПолучения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерверВходящейПочты");
	КонецЕсли;
		
	Если Не ПустаяСтрока(АдресЭлектроннойПочты) И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Почтовый адрес заполнен неверно.';uk='Поштова адреса заповнена невірно.'"), ЭтотОбъект, "АдресЭлектроннойПочты");
		МассивНепроверяемыхРеквизитов.Добавить("АдресЭлектроннойПочты");
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
