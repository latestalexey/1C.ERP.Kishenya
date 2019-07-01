// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мПараметры = Новый Структура();
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	Организация = Параметры.Организация;
	
	ДатаВыплатыНач 			= Параметры.ДатаВыплатыНач;
	ДатаВыплатыКон 			= Параметры.ДатаВыплатыКон;
	НеВключатьЧПников 		= Параметры.НеВключатьЧПников;
	ВыплатыЗПНеРегулярны 	= Параметры.ВыплатыЗПНеРегулярны;
	Подразделение 			= Параметры.Подразделение;
	СортироватьПоИНН		= Параметры.СортироватьПоИНН;
	ОбособленноеПодразделение = Параметры.ОбособленноеПодразделение;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	СтруктураПараметров.Вставить("ОбособленноеПодразделение", ОбособленноеПодразделение);
	ИДКонфигурации = ОпределитьИДКонфигурации();
	СтруктураПараметров.Вставить("ИДКонфигурации", ИДКонфигурации);
	Если ИДКонфигурации = "ЕРП" Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;
	УправлениеЭУ(СтруктураПараметров);
	
	УстановитьВидимостьПодразделения(СтруктураПараметров);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеЭУ(СтруктураПараметров)
	
	СтруктураПараметров.Элементы.ПараметрыВыплаты.Видимость  = НЕ СтруктураПараметров.ВыплатыЗПНеРегулярны;
	Если Не СтруктураПараметров.ИДКонфигурации = "ЕРП" Тогда
		СтруктураПараметров.Элементы.НеВключатьЧПников.Видимость = ЗначениеЗаполнено(СтруктураПараметров.Подразделение);
	Иначе
		Если СтруктураПараметров.ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ Тогда 
			СтруктураПараметров.Элементы.НеВключатьЧПников.Видимость = ЗначениеЗаполнено(СтруктураПараметров.ОбособленноеПодразделение);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры // УправлениеЭУ()
&НаСервере 
Процедура УстановитьВидимостьПодразделения(СтруктураПараметров)
	
	Если СтруктураПараметров.ИДКонфигурации = "ЕРП" Тогда
		Элементы.Подразделение.Видимость = Ложь;
		Если СтруктураПараметров.ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ Тогда 
			Элементы.ОбособленноеПодразделение.Видимость = Истина
		Иначе
			Элементы.ОбособленноеПодразделение.Видимость = Ложь			
		КонецЕсли	
	Иначе
		Элементы.Подразделение.Видимость = Истина;
		Элементы.ОбособленноеПодразделение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // УстановитьВидимостьПодразделения()
&НаСервере
Функция ОпределитьИДКонфигурации()
	
	Возврат РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации();

КонецФункции

&НаСервере
Функция ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ()
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ");
	
КонецФункции
// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть();
	
КонецПроцедуры // Сохранить()

// ПередЗакрытием()
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
			
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
		
	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриЗакрытии()
	
	ВладелецФормы.СтруктураРеквизитовФормы.ДатаВыплатыКон 			= ДатаВыплатыКон;
	ВладелецФормы.СтруктураРеквизитовФормы.ДатаВыплатыНач 			= ДатаВыплатыНач;
	ВладелецФормы.СтруктураРеквизитовФормы.Подразделение 			= Подразделение;
	ВладелецФормы.СтруктураРеквизитовФормы.ОбособленноеПодразделение = ОбособленноеПодразделение; 
	ВладелецФормы.СтруктураРеквизитовФормы.ВыплатыЗПНеРегулярны 	= ВыплатыЗПНеРегулярны;
	ВладелецФормы.СтруктураРеквизитовФормы.НеВключатьЧПников 		= НеВключатьЧПников;
	ВладелецФормы.СтруктураРеквизитовФормы.СортироватьПоИНН 		= СортироватьПоИНН;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_1ДФ_ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РегламентированнаяОтчетность", "РегламентированнаяОтчетность_1ДФ_ЧислоВыплатыЗП", 	  День(ДатаВыплатыКон));	
	
	мПрограммноеЗакрытие = Истина;
	Отказ = Истина;
	
	ПараметрыВозврата = Новый Структура();
	
	Закрыть(ПараметрыВозврата);
	
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры)Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		мПрограммноеЗакрытие = Истина;
		Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыЗПНеРегулярныПриИзменении(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	СтруктураПараметров.Вставить("ОбособленноеПодразделение", ОбособленноеПодразделение);
	ИДКонфигурации = ОпределитьИДКонфигурации();
	СтруктураПараметров.Вставить("ИДКонфигурации", ИДКонфигурации);
	Если ИДКонфигурации = "ЕРП" Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;

	УправлениеЭУ(СтруктураПараметров);
	
	Модифицированность = Истина;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		НеВключатьЧПников = Истина;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	ИДКонфигурации = ОпределитьИДКонфигурации();
	СтруктураПараметров.Вставить("ИДКонфигурации", ИДКонфигурации);
	Если ИДКонфигурации = "ЕРП" Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;

	УправлениеЭУ(СтруктураПараметров);
	
КонецПроцедуры
&НаКлиенте
Процедура ОбособленноеПодразделениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОбособленноеПодразделение) Тогда
		НеВключатьЧПников = Истина;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ВыплатыЗПНеРегулярны", ВыплатыЗПНеРегулярны);
	СтруктураПараметров.Вставить("ОбособленноеПодразделение", ОбособленноеПодразделение);
	ИДКонфигурации = ОпределитьИДКонфигурации();
	СтруктураПараметров.Вставить("ИДКонфигурации", ИДКонфигурации);
	Если ИДКонфигурации = "ЕРП" Тогда
		ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ = ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ();
		СтруктураПараметров.Вставить("ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ", ИспользоватьУчетОбособленныхПодразделенийДляНДФЛ);
	КонецЕсли;
	
	УправлениеЭУ(СтруктураПараметров);
	
КонецПроцедуры

