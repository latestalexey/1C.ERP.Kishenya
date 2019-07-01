
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Помещение = Параметры.Помещение;
	Склад = Параметры.Склад;
	
	ИдентификаторСкладаПомещения = Строка(Склад.УникальныйИдентификатор()) +  Строка(Помещение.УникальныйИдентификатор()) + Строка(Помещение.УникальныйИдентификатор());
	
	НастройкаФормированияПоПомещениям = 0;
	ПоОдномуПомещению = Ложь;
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ФормаУправлениеОтгрузкойФормаНастроекНастройкиФормы" + ИдентификаторСкладаПомещения, "");
	Если Настройки <> Неопределено Тогда
		Если Настройки.Свойство("ЗонаОтгрузки") Тогда	
			ЗонаОтгрузки = Настройки.ЗонаОтгрузки;		
		КонецЕсли;
		Если Настройки.Свойство("НазначитьЗонуОтгрузки") Тогда	
			НазначитьЗонуОтгрузки = Настройки.НазначитьЗонуОтгрузки;		
		КонецЕсли;
		Если Настройки.Свойство("ПоВсемРаспоряжениям") Тогда	
			ПоВсемРаспоряжениям = Настройки.ПоВсемРаспоряжениям;		
		КонецЕсли;
		Если Настройки.Свойство("ПоОдномуПомещению") Тогда	
			ПоОдномуПомещению = Настройки.ПоОдномуПомещению;		
		КонецЕсли;
		Если Настройки.Свойство("НастройкаФормированияПоПомещениям") Тогда	
			НастройкаФормированияПоПомещениям = Настройки.НастройкаФормированияПоПомещениям;		
		КонецЕсли;
	КонецЕсли;
		
	Параметры.Свойство("ИспользоватьСкладскиеПомещения", ИспользоватьСкладскиеПомещения);
	
	УстановитьВидимость();
	УстановитьУмолчания();
	УстановитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначитьЗонуОтгрузкиПриИзменении(Элемент)
	Элементы.ЗонаОтгрузки.Доступность           = НазначитьЗонуОтгрузки;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаФормированияПоПомещениямПриИзменении(Элемент)
	Если НастройкаФормированияПоПомещениям = "0" Тогда
		ПоОдномуПомещению = Ложь;
	Иначе	
		ПоОдномуПомещению = Истина;		
	КонецЕсли;			
	
	УстановитьДоступность()

КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	
	ПомещениеПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьБезСохранения(Команда)
	Закрыть(КодВозвратаДиалога.Отмена);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьССохранением(Команда)
	
	ОчиститьСообщения();
	ОшибкаПроверки = Ложь;

	Если Элементы.НазначатьЗонуОтгрузки.Доступность 
		И Элементы.НазначатьЗонуОтгрузки.Видимость
		И НазначитьЗонуОтгрузки
		И Не ЗначениеЗаполнено(ЗонаОтгрузки) Тогда
		
		ТекстСообщения = НСтр("ru='Поле ""Зона отгрузки"" не заполнено.';uk='Поле ""Зона відвантаження"" не заповнено.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ЗонаОтгрузки",);
		
		ОшибкаПроверки = Истина;
		
	КонецЕсли;
	
	Если ИспользоватьСкладскиеПомещения
		И ПоОдномуПомещению
		И Не ЗначениеЗаполнено(Помещение)Тогда
		ТекстСообщения = НСтр("ru='Поле ""Помещение"" не заполнено.';uk='Поле ""Приміщення"" не заповнено.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ЗонаОтгрузки",);
		
		ОшибкаПроверки = Истина;		
	КонецЕсли;
	
	Если ОшибкаПроверки Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторСкладаПомещения = Строка(Склад.УникальныйИдентификатор()) + Строка(Помещение.УникальныйИдентификатор()) + Строка(Помещение.УникальныйИдентификатор());

	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ЗонаОтгрузки",ЗонаОтгрузки);
	ПараметрыЗакрытия.Вставить("НазначитьЗонуОтгрузки", НазначитьЗонуОтгрузки);   
	ПараметрыЗакрытия.Вставить("ПоВсемРаспоряжениям", ПоВсемРаспоряжениям);	
	ПараметрыЗакрытия.Вставить("ПоОдномуПомещению", ПоОдномуПомещению);
	ПараметрыЗакрытия.Вставить("НастройкаФормированияПоПомещениям", НастройкаФормированияПоПомещениям);
	
	ХранилищеОбщихНастроекСохранить(ИдентификаторСкладаПомещения, ПараметрыЗакрытия);
	
	ПараметрыЗакрытия.Вставить("ПомещениеДляСозданияРасходныхОрдеров", Помещение);
	Если ИспользоватьСкладскиеПомещения Тогда
		ПараметрыЗакрытия.Вставить("ПоОдномуПомещению", ПоОдномуПомещению);
		Если Не ПоОдномуПомещению ИЛИ (ИспользоватьСкладскиеПомещения И НЕ ЗначениеЗаполнено(Помещение)) Тогда
			ПараметрыЗакрытия.Вставить("НазначитьЗонуОтгрузки", Ложь);
		КонецЕсли;
	Иначе
		ПараметрыЗакрытия.Вставить("ПоОдномуПомещению", Ложь);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВладелецФормы,ПараметрыЗакрытия,
		"ЗонаОтгрузки,НазначитьЗонуОтгрузки,ПоВсемРаспоряжениям,ПоОдномуПомещению,ПомещениеДляСозданияРасходныхОрдеров");
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПомещениеПриИзмененииНаСервере()	
	ИспользоватьАдресноеХранение = ИспользоватьАдресноеХранение(Склад, Помещение);
	Элементы.НазначатьЗонуОтгрузки.Видимость = ИспользоватьАдресноеХранение;
	Элементы.ЗонаОтгрузки.Видимость			 = ИспользоватьАдресноеХранение;	
	
	УстановитьДоступность();
	УстановитьУмолчания();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользоватьАдресноеХранение(Склад, Помещение)
	
	Возврат СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение)
		
КонецФункции

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ПоВсемРаспоряжениям.Видимость 	    = (Параметры.Операция = "ФормированиеОрдеров")
												   Или (Параметры.Операция = "ФормированиеОрдеровАдресныйСклад");
												   											   
	Элементы.НастройкаФормированияПоПомещениям.Видимость = ИспользоватьСкладскиеПомещения;
	Элементы.Помещение.Видимость		   = ИспользоватьСкладскиеПомещения;
	Элементы.ДекорацияПомещение.Видимость  = ИспользоватьСкладскиеПомещения;
											   											   
	ЗонаОтгрузкиВидимость       = (Параметры.Операция = "ВыборЗоныОтгрузки")
													Или (Параметры.Операция = "ФормированиеОрдеровАдресныйСклад")
													Или (Параметры.Операция = "ФормированиеЗаданий");		
													
	Элементы.НазначатьЗонуОтгрузки.Видимость = ЗонаОтгрузкиВидимость;
	Элементы.ЗонаОтгрузки.Видимость			 = ЗонаОтгрузкиВидимость;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУмолчания()
	
	Если Не ЗначениеЗаполнено(ЗонаОтгрузки) Тогда
		ЗонаОтгрузки = Справочники.СкладскиеЯчейки.ЗонаОтгрузкиПоУмолчанию(Склад,Помещение);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	Элементы.НазначатьЗонуОтгрузки.Доступность  = (Не ИспользоватьСкладскиеПомещения Или (ПоОдномуПомещению И ЗначениеЗаполнено(Помещение)));
	Элементы.ЗонаОтгрузки.Доступность           = НазначитьЗонуОтгрузки И (Не ИспользоватьСкладскиеПомещения Или (ПоОдномуПомещению И ЗначениеЗаполнено(Помещение)));
	Элементы.Помещение.Доступность	            = ПоОдномуПомещению;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ХранилищеОбщихНастроекСохранить(ИдентификаторСкладаПомещения, ПараметрыЗакрытия)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ФормаУправлениеОтгрузкойФормаНастроекНастройкиФормы" + ИдентификаторСкладаПомещения,
		 "",
		ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
