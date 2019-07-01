////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки электронных документов.
// 
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает номер версии библиотеки ОбменСКонтрагентами.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "1.3.3.11";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаЭлектронныхДокументов";
	Описание.Версия = ВерсияБиблиотеки();
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	ЕстьОбменССайтами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменССайтами");

	Если ЕстьОбменСКонтрагентами Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.4.0";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВидыДокументов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.5.0";
		Обработчик.Процедура = "РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ОбновитьВерсиюРегламентаЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.3.7";
		Обработчик.Процедура = "РегистрыСведений.ЖурналСобытийЭД.ОбновитьСтатусыЭД";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.5.1";
		Обработчик.Процедура = "ОбменСКонтрагентамиОбработчикиОбновления.ОбработатьКорректировочныеСчетаФактуры";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.6.3";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьВерсииФорматов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.7.1";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ПеренестиСертификатАвторизацииВТЧ";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.7.4";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьВерсииФорматовИсходящихЭДИПакета";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.9.1";
		Обработчик.Процедура = "Справочники.УдалитьСертификатыЭП.ЗаполнитьСрокДействия";
		Обработчик.НачальноеЗаполнение = Ложь;
			
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.2";
		Обработчик.Процедура = "РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ЗаменитьС1На2ВерсиюРегламентаЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.4";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ЗаполнитьНаименованиеФайла";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.6";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсииФорматовИсходящихЭДИПакета";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.14.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьИспользованиеКриптографии";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.14.2";
		Обработчик.Процедура = "Документы.ПроизвольныйЭД.ЗаполнитьТипДокумента";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.2.1";
		Обработчик.Процедура = "ОбменСКонтрагентамиОбработчикиОбновления.ЗаполнитьДанныеОПрофиляхНастроекЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.2.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсиюФорматаИсходящихЭД207_208";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "Справочники.УдалитьСертификатыЭП.ПеренестиНастройкиСертификатов";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "ОбменСКонтрагентамиОбработчикиОбновления.ПеренестиНастройкиКонтекстаКриптографии";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ИзменитьСтатусыПроизвольныхЭДСНеОтправленНаСформирован";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсиюФорматаИсходящихЭД501_502";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.8";
		Обработчик.Процедура = "РегистрыСведений.СостоянияЭД.УдалитьСостояниеУдалитьОжидаетсяИзвещение";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("a351a845-1550-45d5-af0f-b3a5739a90ee");
		Обработчик.Комментарий = НСтр("ru='Изменяет состояние документов с ""Ожидается извещение"" на ""Ожидается извещение о получении""';uk='Змінює стан документів з ""Очікується повідомлення"" на ""Очікується повідомлення про одержання""'");
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.9";
		Обработчик.Процедура = "ОбменСКонтрагентамиОбработчикиОбновления.ПроверитьКонтрагентовБЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("28ce9ce8-fd89-44ed-9016-a904d4ff0990");
		Обработчик.Комментарий = НСтр("ru='Проверяет контрагентов на подключение к сервису 1С-ЭДО.';uk='Перевіряє контрагентів на підключення до сервісу "" 1С-ЕДО.'");
		Обработчик.НачальноеЗаполнение = Истина;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.4";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.УдалитьОтветныеТитулы";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.22";
		Обработчик.Процедура = "ОбменСКонтрагентамиОбработчикиОбновления.НастроитьАвтоПереходНаНовыеВерсииФорматовЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.22";
		Обработчик.Процедура = "ОбменСКонтрагентамиОбработчикиОбновления.УдалитьУстаревшиеОбработчики";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
	КонецЕсли;
	
	Если ЕстьОбменССайтами Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.6.2";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.УстановитьЗначениеРеквизитовВыгрузки";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.3";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитФормыСоответствиеСтатусовЗаказов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.3";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитФормыЕдиницаИзмеренияНовойНоменклатуры";
		Обработчик.НачальноеЗаполнение = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	

КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти

