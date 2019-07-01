////////////////////////////////////////////////////////////////////////////////
// Варианты отчетов - Форма отчета (переопределяемый)
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных - ТаблицаЗначений - Таблица связей.
//       * ПодчиненныйРеквизит - Строка - Имя реквизита подчиненного объекта метаданных.
//       * ПодчиненныйТип      - Тип    - Тип подчиненного объекта метаданных.
//       * ВедущийТип          - Тип    - Тип ведущего объекта метаданных.
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   СвойстваНастройки - Структура - Описание настройки отчета, которая будет выведена в форме отчета.
//       * ОписаниеТипов - ОписаниеТипов -
//           Тип настройки.
//       * ЗначенияДляВыбора - СписокЗначений -
//           Объекты, которые будут предложены пользователю в списке выбора.
//           Дополняет список объектов, уже выбранных пользователем ранее.
//       * ЗапросЗначенийВыбора - Запрос -
//           Возвращает объекты, которыми необходимо дополнить ЗначенияДляВыбора.
//           Первой колонкой (с 0м индексом) должен выбираться объект,
//           который следует добавить в ЗначенияДляВыбора.Значение.
//           Для отключения автозаполнения
//           в свойство ЗапросЗначенийВыбора.Текст следует записать пустую строку.
//       * ОграничиватьВыборУказаннымиЗначениями - Булево -
//           Когда Истина, то выбор пользователя будет ограничен значениями,
//           указанными в ЗначенияДляВыбора (его конечным состоянием).
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	// Автозаполнение параметров и отборов для всех отчетов
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") 
		И СвойстваНастройки.ОписаниеТипов.Типы().Количество() = 1
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Валюты")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора = ЗапросДляОтбораВалюта();
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") 
		И СвойстваНастройки.ОписаниеТипов.Типы().Количество() = 1
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Организации")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора = ЗапросДляОтбораОрганизация();
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") 
		И СвойстваНастройки.ОписаниеТипов.Типы().Количество() = 1
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.СтруктураПредприятия")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора = ЗапросДляОтбораПодразделение();
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") 
		И СвойстваНастройки.ОписаниеТипов.Типы().Количество() = 1
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.НаправленияДеятельности")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора = ЗапросДляОтбораНаправлениеДятельности();
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
	Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("ПеречислениеСсылка.ХозяйственныеОперации")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "";
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Ложь;
	КонецЕсли;
	Если Константы.БазоваяВерсия.Получить()
		И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.НастройкиХозяйственныхОпераций")) Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "
		|ВЫБРАТЬ
		|	НастройкиХозяйственныхОпераций.Ссылка
		|ИЗ
		|	Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
		|ГДЕ
		|	НастройкиХозяйственныхОпераций.Ссылка В(
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ЗакупкаУПоставщика),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ЗакупкаЧерезПодотчетноеЛицо),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПриемНаКомиссию),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровПоставщику),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровКомитенту),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.РеализацияКлиенту),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПередачаНаКомиссию),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратОтКомиссионера),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратТоваровОтКлиента),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВозвратОтРозничногоПокупателя),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВнутренняяПередачаТоваров),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеремещениеТоваров),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.СписаниеТоваровПоТребованию),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.СторноСписанияНаРасходы),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВыдачаДенежныхСредствВКассуККМ),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ВыдачаДенежныхСредствПодотчетнику),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ИнкассацияДенежныхСредствВБанк),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ИнкассацияДенежныхСредствИзБанка),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.КонвертацияВалюты),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ОплатаПоставщику),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеречислениеДенежныхСредствНаДругойСчет),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПеречислениеВБюджет),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзБанка),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзДругойКассы),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзДругойОрганизации),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеДенежныхСредствИзКассыККМ),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеОплатыОтКлиента),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.ПрочееПоступлениеДенежныхСредств),
		|		Значение(Справочник.НастройкиХозяйственныхОпераций.СдачаДенежныхСредствВБанк)
		|)";
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
	КонецЕсли;
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
	//++ НЕ УТ
	ИнтеграцияССППР.ПриСозданииФормыОтчета(Форма);
	//-- НЕ УТ
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
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(Форма, НовыеНастройкиКД);
	
	// Преобразование расширенных отборов "через точку"
	ПреобразоватьРасширенныеОтборы(Форма, Форма.Отчет.КомпоновщикНастроек);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(Форма, НовыеНастройкиКД)
	ИмяОтчета = ВариантыОтчетовУТПереопределяемый.ИмяОтчетаПоКлючуОбъекта(Форма);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Организация");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "СтруктураПредприятия.Организация");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ПоказыватьПродажи");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Касса");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "БанковскийСчет");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Склад");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "СтруктураПредприятия.Склад");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Подразделение");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Подразделение");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Контрагент");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Контрагент");
	КонецЕсли;
	
	// Валютные настройки отключаются только для отчетов без показателя "Себестоимость"
	
	Если (ИмяОтчета = "ДебиторскаяЗадолженность"
		ИЛИ ИмяОтчета = "ДебиторскаяЗадолженностьДоляПросрочки"
		ИЛИ ИмяОтчета = "КартаПродаж"
		ИЛИ ИмяОтчета = "КредиторскаяЗадолженность"
		ИЛИ ИмяОтчета = "ПлатежнаяДисциплинаКлиентов"
		ИЛИ ИмяОтчета = "АнализДоходовРасходов"
		ИЛИ ИмяОтчета = "УправленческийБаланс")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		ИЛИ ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Валюта");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Валюта");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ВалютаОтчета");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ДанныеОтчета");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ДанныеПоДенежнымСредствам");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ДанныеПоРасчетам");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ВыводитьСуммы");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ВидЦены");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ОценкаЗапасовПоВидуЦен");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "ЕдиницыКоличества");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами")
		И (ИмяОтчета = "ДебиторскаяЗадолженность"
		Или ИмяОтчета = "РасчетыСКлиентами"
		Или ИмяОтчета = "СостояниеРасчетовСКлиентами") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Договор");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками")
		И (ИмяОтчета = "КредиторскаяЗадолженность"
		Или ИмяОтчета = "РасчетыСПоставщиками"
		Или ИмяОтчета = "СостояниеРасчетовСПоставщиками") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Договор");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Договор");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками")
		И ИмяОтчета = "РасчетыСПартнерами" Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "Договор");
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(НовыеНастройкиКД, "АналитикаОборотов.Договор");
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(НовыеНастройкиКД, "Договор");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("КонтролироватьВыдачуПодОтчетВРазрезеЦелей")
		И (ИмяОтчета = "КонтрольВыданныхПодотчетномуЛицуАвансовПоЗаявке"
			Или ИмяОтчета = "КонтрольОперацийСДенежнымиСредствами") Тогда
		КомпоновкаДанныхСервер.УдалитьГруппировкуИзВсехНастроекОтчета(НовыеНастройкиКД, "ЦельВыдачи");
	КонецЕсли;
	
КонецПроцедуры

Функция ЗапросДляОтбораОрганизация()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	(&ИспользоватьУправленческуюОрганизацию
	|			ИЛИ НЕ &ИспользоватьУправленческуюОрганизацию
	|				И НЕ Организации.Предопределенный)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	Запрос.УстановитьПараметр("ИспользоватьУправленческуюОрганизацию", ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
	
	Возврат Запрос;
КонецФункции

Функция ЗапросДляОтбораПодразделение()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктураПредприятия.Ссылка
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтруктураПредприятия.Наименование";
	
	Возврат Запрос;
КонецФункции

Функция ЗапросДляОтбораНаправлениеДятельности()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НаправленияДеятельности.Ссылка
	|ИЗ
	|	Справочник.НаправленияДеятельности КАК НаправленияДеятельности
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаправленияДеятельности.Наименование";
	
	Возврат Запрос;
КонецФункции

Процедура ПреобразоватьРасширенныеОтборы(ЭтаФорма, КомпоновщикНастроек)
	Для Каждого Отбор Из ЭтаФорма.ФормаПараметры.Отбор Цикл
		Если ТипЗнч(Отбор.Значение) = Тип("Массив") Тогда
			СписокЗначенийОтбора = Новый СписокЗначений;
			СписокЗначенийОтбора.ЗагрузитьЗначения(Отбор.Значение);
		КонецЕсли;
		Если СтрНайти(Отбор.Ключ, "_") Тогда
			КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
				КомпоновщикНастроек, 
				СтрЗаменить(Отбор.Ключ, "_","."),
				?(ТипЗнч(Отбор.Значение) = Тип("Массив"), СписокЗначенийОтбора, Отбор.Значение),
				?(ТипЗнч(Отбор.Значение) = Тип("СписокЗначений") ИЛИ ТипЗнч(Отбор.Значение) = Тип("Массив"), ВидСравненияКомпоновкиДанных.ВСписке, Неопределено),,
				Истина);
			ЭтаФорма.ФормаПараметры.Отбор.Удалить(Отбор.Ключ);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ЗапросДляОтбораВалюта()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюты.Код";
	
	Возврат Запрос;
КонецФункции

#КонецОбласти