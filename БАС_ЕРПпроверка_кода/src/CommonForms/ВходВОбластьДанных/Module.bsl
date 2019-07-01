#Область ЛокальныеПеременные

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьИнтерфейс = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВойтиВОбластьДанных(Команда)
	
	Если ОсуществленВходВОбластьДанных() Тогда
		
		ОбработкаЗавершения = Новый ОписаниеОповещения(
			"ПродолжениеВходаВОбластьДанныхПослеДействийПередЗавершениемРаботыСистемы", ЭтотОбъект);
			
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(, ОбработкаЗавершения);
	Иначе
		ВойтиВОбластьДанныхПослеВыхода();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыйтиИзОбластиДанных(Команда)
	
	Если ОсуществленВходВОбластьДанных() Тогда
		
		ОбработкаЗавершения = Новый ОписаниеОповещения(
			"ПродолжениеВыходаИзОбластиДанныхПослеДействийПередЗавершениемРаботыСистемы", ЭтотОбъект);
		
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(, ОбработкаЗавершения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПриНеобходимости()
	
	Если ОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВходаВОбластьДанныхПослеДействийПередЗавершениемРаботыСистемы(Результат, Неопределен) Экспорт
	
	Если Результат.Отказ Тогда
		Активизировать();
		ОбновитьИнтерфейсПриНеобходимости();
		Возврат;
	КонецЕсли;
	
	ВыйтиИзОбластиДанныхНаСервере();
	ОбновитьИнтерфейс = Истина;
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
	
	ВойтиВОбластьДанныхПослеВыхода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВойтиВОбластьДанныхПослеВыхода()
	
	Если НЕ УказаннаяОбластьДанныхЗаполнена(ОбластьДанных) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВойтиВОбластьДанныхПослеВыхода2", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Выбранная область данных не используется, продолжить вход?';uk='Обрана область даних не використовується, продовжити вхід?'"),
			РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	ВойтиВОбластьДанныхПослеВыхода2();
	
КонецПроцедуры

&НаКлиенте
Процедура ВойтиВОбластьДанныхПослеВыхода2(Ответ = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		ОбновитьИнтерфейсПриНеобходимости();
		Возврат;
	КонецЕсли;
	
	ВойтиВОбластьДанныхНаСервере(ОбластьДанных);
	
	ОбновитьИнтерфейс = Истина;
	
	ОбработкаЗавершения = Новый ОписаниеОповещения(
		"ПродолжениеВходаВОбластьДанныхПослеДействийПередНачаломРаботыСистемы", ЭтотОбъект);
	
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы(ОбработкаЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВходаВОбластьДанныхПослеДействийПередНачаломРаботыСистемы(Результат, Неопределен) Экспорт
	
	Если Результат.Отказ Тогда
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
		ОбновитьИнтерфейсПриНеобходимости();
		Активизировать();
	Иначе
		ОбработкаЗавершения = Новый ОписаниеОповещения(
			"ПродолжениеВходаВОбластьДанныхПослеДействийПриНачалеРаботыСистемы", ЭтотОбъект);
		
		СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы(ОбработкаЗавершения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВходаВОбластьДанныхПослеДействийПриНачалеРаботыСистемы(Результат, Неопределен) Экспорт
	
	Если Результат.Отказ Тогда
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
	КонецЕсли;
	
	ОбновитьИнтерфейсПриНеобходимости();
	Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыходаИзОбластиДанныхПослеДействийПередЗавершениемРаботыСистемы(Результат, Неопределен) Экспорт
	
	Если Результат.Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВыйтиИзОбластиДанныхНаСервере();
	ОбновитьИнтерфейс();
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
	
	Активизировать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УказаннаяОбластьДанныхЗаполнена(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
	ЭлементБлокировки.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбластиДанных.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|ГДЕ
	|	ОбластиДанных.ОбластьДанныхВспомогательныеДанные = &ОбластьДанных";
	Запрос.УстановитьПараметр("ОбластьДанных", ОбластьДанных);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Статус = Перечисления.СтатусыОбластейДанных.Используется
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВойтиВОбластьДанныхНаСервере(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	
	НачатьТранзакцию();
	
	Попытка
		
		КлючОбласти = РаботаВМоделиСервиса.СоздатьКлючЗаписиРегистраСведенийВспомогательныхДанных(
			РегистрыСведений.ОбластиДанных,
			Новый Структура(РаботаВМоделиСервиса.РазделительВспомогательныхДанных(), ОбластьДанных));
		ЗаблокироватьДанныеДляРедактирования(КлючОбласти);
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Элемент.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
		Элемент.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		МенеджерЗаписи.Прочитать();
		Если Не МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
			МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Используется;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(КлючОбласти);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВыйтиИзОбластиДанныхНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОсуществленВходВОбластьДанных()
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОбщегоНазначения.ИспользованиеРазделителяСеанса();
	
КонецФункции

#КонецОбласти
