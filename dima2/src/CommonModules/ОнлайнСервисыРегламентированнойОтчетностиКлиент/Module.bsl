#Область НастройкиДоступаКРесурсуСАктуальнымиСведениями


Процедура ПродолжитьПослеПроверкиПодключенияКИПП(ОписаниеОповещенияДляЗавершения)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияДляЗавершения", ОписаниеОповещенияДляЗавершения);
	Оповещение = Новый ОписаниеОповещения("ПродолжитьПослеПроверкиПодключенияКИППЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ИнтернетПоддержкаПользователейБРОКлиент.ПроверитьВозможностьВыполненияОперации(Оповещение, ОписаниеОповещенияДляЗавершения.ДополнительныеПараметры.КонтекстФормы);
	
КонецПроцедуры

Процедура ПродолжитьПослеПроверкиПодключенияКИППЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	ОписаниеОповещенияДляЗавершения = ВходящийКонтекст.ОписаниеОповещенияДляЗавершения;
	
	ПроверкаВыполнена = Ложь;
	
	Если Результат.Выполнено И Результат.ВыполнениеРазрешено Тогда
		ПроверкаВыполнена = Истина;
	ИначеЕсли Результат.Выполнено И НЕ Результат.ВыполнениеРазрешено Тогда
		ПоказатьПредупреждение(, НСтр("ru='Нет доступа к интернет-поддержке пользователя - внешние формы не будут загружаться автоматически.';uk='Немає доступу до інтернет-підтримки користувача - зовнішні форми не будуть завантажуватися автоматично.'"));
	ИначеЕсли НЕ Результат.Выполнено Тогда
		ПоказатьПредупреждение(, НСтр("ru='При проверке доступа к интернет-поддержке пользователя возникла неизвестная ошибка.';uk='При перевірці доступу до інтернет-підтримки користувача виникла невідома помилка.'"));
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияДляЗавершения, ПроверкаВыполнена);
	
КонецПроцедуры

Процедура ЗапроситьПараметрыПрокси(Знач ОписаниеОповещенияДляПродолжения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияДляПродолжения", ОписаниеОповещенияДляПродолжения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапроситьПараметрыПроксиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",,,,,, ОписаниеОповещения);

КонецПроцедуры

Процедура ЗапроситьПараметрыПроксиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещенияДляПродолжения = ДополнительныеПараметры.ОписаниеОповещенияДляПродолжения;
	Если ОписаниеОповещенияДляПродолжения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияДляПродолжения, Результат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

Процедура АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимости(Форма) Экспорт
	
	НастройкиМеханизмаОнлайнСервисов = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьНастройкиМеханизмаОнлайнСервисовРО();
	
	// если механизм выключен, то прервемся
	Если НЕ НастройкиМеханизмаОнлайнСервисов.Использовать Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиМеханизмаОнлайнСервисов = ДополнительныеПараметры.НастройкиМеханизмаОнлайнСервисов;
	
	// Если нет доступа к регистру, то не выполняем актуализацию
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЕстьПравоИзмененияРегистраРесурсыМеханизмаОнлайнСервисовРО() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещенияДляЗавершения = Новый ОписаниеОповещения("АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если НастройкиМеханизмаОнлайнСервисов.АвтоматическиПодключатьФормыРО = Истина
		И НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		ПродолжитьПослеПроверкиПодключенияКИПП(ОписаниеОповещенияДляЗавершения);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияДляЗавершения, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.КонтекстФормы;
	
	УникальныйИдентификаторФормы = Форма;
	
	РезультатВыполненияЗадания = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЗапуститьФоновоеЗаданиеАктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРО(УникальныйИдентификаторФормы, Результат);
	
	
КонецПроцедуры

#Область МеханизмБлокировок

Процедура ПроверкаОнлайнБлокировки(ВыполняемоеОповещение, Объект, БлокируемаяФункция = "И") Экспорт
	
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
КонецПроцедуры


Процедура ПроверкаОнлайнБлокировкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

Процедура ПроверкаФормыПоПериодуПрименения(ВыполняемоеОповещение, Форма) Экспорт
	
	// если механизм выключен, то прервем проверку
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПроверкаФормыПоПериодуПримененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

Процедура ПроверкаФорматаПоПериодуПрименения(ВыполняемоеОповещение, Форма) Экспорт
	
	// если механизм выключен, то прервем проверку
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаФорматаПоПериодуПримененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

#Область ОткрытиеФормУведомлений

#КонецОбласти

#КонецОбласти

#Область СобытияРегламентированныхОтчетов

// Параметры:
//	ВыполняемоеОповещение                  - ОписаниеОповещения - Описание оповещения, которое будет вызвано после открытия формы регламентированного отчета
//                                                       В качестве результата описания оповещения передается булевская переменная. Если Истина - форму нужно закрыть
Процедура ПередОткрытиемФормыРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередОткрытиемФормыРегламентированногоОтчетаПродолжение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма);
	
КонецПроцедуры

Процедура ПередОткрытиемФормыРегламентированногоОтчетаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Форма 					= ДополнительныеПараметры.Форма;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	// ПроверкаФормыПоПериодуПрименения
	НовыеДополнительныеПараметры = Новый Структура();
	НовыеДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	НовыеДополнительныеПараметры.Вставить("Отказ", Отказ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередОткрытиемФормыРегламентированногоОтчетаЗавершение", ЭтотОбъект, НовыеДополнительныеПараметры);
	
	ПроверкаФормыПоПериодуПрименения(ОписаниеОповещения, Форма);
	
КонецПроцедуры

Процедура ПередОткрытиемФормыРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередПечатьюРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередПечатьюРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "П");
	
КонецПроцедуры

Процедура ПередПечатьюРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередПечатьюМЧБРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередПечатьюМЧБРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "ПВ");
	
КонецПроцедуры

Процедура ПередПечатьюМЧБРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередВыгрузкойРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередВыгрузкойРегламентированногоОтчетаПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "В");
	
КонецПроцедуры

Процедура ПередВыгрузкойРегламентированногоОтчетаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Форма 					= ДополнительныеПараметры.Форма;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	// ПроверкаФорматаПоПериодуПрименения
	НовыеДополнительныеПараметры = Новый Структура();
	НовыеДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	НовыеДополнительныеПараметры.Вставить("Отказ", Отказ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередВыгрузкойРегламентированногоОтчетаЗавершение", ЭтотОбъект, НовыеДополнительныеПараметры);
	
	ПроверкаФорматаПоПериодуПрименения(ОписаниеОповещения, Форма);
	
КонецПроцедуры

Процедура ПередВыгрузкойРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередЗаполнениемРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаполнениемРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "З");
	
КонецПроцедуры

Процедура ПередЗаполнениемРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередОтправкойРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередОтправкойРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "О");
	
КонецПроцедуры

Процедура ПередОтправкойРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если Результат <> Истина Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИДОтчета(Объект)
	
	СоставляющиеИмениФормы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Объект.ИмяФормы, ".");
	
	Если СоставляющиеИмениФормы.Количество() >= 1 Тогда
		ИДОтчета = ВРЕГ(СоставляющиеИмениФормы[1]);
	Иначе
		ИДОтчета = Неопределено;
	КонецЕсли;
	
	Возврат ИДОтчета;
	
КонецФункции


Функция ПолучитьКраткуюВерсиюОтчета(ОбъектОтчет) Экспорт

	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(ОбъектОтчет, "мВерсияОтчета") Тогда
		ПолнаяВерсияОтчета = ОбъектОтчет.мВерсияОтчета;
		КраткаяВерсия = ВыделитьКраткуюВерсиюОтчетаИзПолной(ПолнаяВерсияОтчета);
		Возврат ?(ЗначениеЗаполнено(КраткаяВерсия), КраткаяВерсия, Неопределено);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ВыделитьКраткуюВерсиюОтчетаИзПолной(ПолнаяВерсияОтчета)
	
	Если НЕ ЗначениеЗаполнено(ПолнаяВерсияОтчета) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВхождениеПробела = СтрНайти(ПолнаяВерсияОтчета, " ");
	Если ВхождениеПробела = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат СокрЛП(Сред(ПолнаяВерсияОтчета, ВхождениеПробела + 1));
	КонецЕсли;
	
КонецФункции

Процедура ПопытатьсяПерейтиПоНавигационнойСсылке(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		ПерейтиПоНавигационнойСсылке(Ссылка);
		
	Исключение
		
		ПоказатьПредупреждение(, НСтр("ru='Не удалось перейти по указанной ссылке!';uk='Не вдалося перейти за вказаним посиланням!'"));
		
	КонецПопытки; 
	
КонецПроцедуры


#КонецОбласти
