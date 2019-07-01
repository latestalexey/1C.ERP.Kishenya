
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;

	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок") Тогда
		Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланЗакупок, НСтр("ru='Плана закупок';uk='Плану купівель'"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродажПоКатегориям") Тогда
		Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланПродажПоКатегориям, НСтр("ru='Плана продаж по категориям';uk='Плану продажу по категоріях'"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") Тогда
		Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланПродаж, НСтр("ru='Плана продаж';uk='Плану продажів'"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки") Тогда
		Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланСборкиРазборки, НСтр("ru='Плана сборки (разборки)';uk='План збирання (розбирання)'"));
	КонецЕсли; 
	//++ НЕ УТ
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства") Тогда
		Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланПроизводства, НСтр("ru='Плана производства';uk='Плану виробництва'"));
	КонецЕсли;
	//-- НЕ УТ
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	ИспользоватьФорматыМагазинов = ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов");
	ИспользоватьНесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	ВыборСклада = ИспользоватьНесколькоСкладов И НЕ ИспользоватьФорматыМагазинов;
	ВыборФормата = ИспользоватьФорматыМагазинов И НЕ ИспользоватьНесколькоСкладов;
	ВыборСкладаИлиФорматам = ИспользоватьНесколькоСкладов И ИспользоватьФорматыМагазинов;
	
	Элементы.ГруппаЗаполнятьСкладВТЧ.Видимость = ИспользоватьНесколькоСкладов;
	Элементы.ЗаполнятьСкладПродажи.Видимость = ВыборСклада;
	Элементы.ЗаполнятьСкладПродажиПоКатегориям.Видимость = ВыборСклада;
	Элементы.ЗаполнятьФорматМагазинаПродажи.Видимость = ВыборФормата;
	Элементы.ЗаполнятьФорматМагазинаПодажиПоКатегориям.Видимость = ВыборФормата;
	Элементы.ВарианЗаполненияСкладФорматМагазинаПродажи.Видимость = ВыборСкладаИлиФорматам;
	Элементы.ВарианЗаполненияСкладФорматМагазинаПродажиПоКатегориям.Видимость = ВыборСкладаИлиФорматам;
	
	Элементы.ЗаполнятьСоглашениеПродажи.Видимость = ИспользоватьСоглашенияСКлиентами;
	Элементы.ЗаполнятьСоглашение.Видимость = ИспользоватьСоглашенияСКлиентами;
	Элементы.ГруппаЗаполнятьСоглашениеВТЧ.Видимость = ИспользоватьСоглашенияСКлиентами;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	АдресПравилаЗаполнения = ПоместитьВоВременноеХранилище(
		ТекущийОбъект.ПравилоЗаполнения.Выгрузить(),
		УникальныйИдентификатор);
	
	ПриЧтенииСозданииНаСервере();
	
	СтруктураНастроекОбъекта = ТекущийОбъект.СтруктураНастроек.Получить();
	Если ТипЗнч(СтруктураНастроекОбъекта) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, СтруктураНастроекОбъекта);
	КонецЕсли; 
	
	Если ТипЗнч(СтруктураНастроекОбъекта) = Тип("Структура") И СтруктураНастроекОбъекта.Свойство("ПользовательскиеНастройки") Тогда
		АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(СтруктураНастроекОбъекта.ПользовательскиеНастройки, УникальныйИдентификатор);
	Иначе
		АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ЗаполнятьПартнера = ЗаполнятьПартнера И (ТекущийОбъект.ЗаполнятьПоФормуле ИЛИ НЕ ТекущийОбъект.ЗаполнятьПартнераВТЧ);
	ТекущийОбъект.ЗаполнятьПартнераВТЧ = ЗаполнятьПартнера И ТекущийОбъект.ЗаполнятьПартнераВТЧ И НЕ ТекущийОбъект.ЗаполнятьПоФормуле;
	ТекущийОбъект.ЗаполнятьСоглашение = ЗаполнятьПартнера И ЗаполнятьСоглашение 
		И (ТекущийОбъект.ЗаполнятьПоФормуле ИЛИ НЕ ТекущийОбъект.ЗаполнятьСоглашениеВТЧ);
	ТекущийОбъект.ЗаполнятьСоглашениеВТЧ = ЗаполнятьПартнера И ЗаполнятьСоглашение 
		И (ТекущийОбъект.ЗаполнятьСоглашениеВТЧ ИЛИ ТекущийОбъект.ЗаполнятьПартнераВТЧ) И НЕ ТекущийОбъект.ЗаполнятьПоФормуле;
	
	Если ЭтоАдресВременногоХранилища(АдресПравилаЗаполнения) Тогда
		ТекущийОбъект.ПравилоЗаполнения.Загрузить(ПолучитьИзВременногоХранилища(АдресПравилаЗаполнения));
	КонецЕсли;
	Если ЭтоАдресВременногоХранилища(АдресПользовательскихНастроек) Тогда
		СтруктураНастроек.Вставить("ПользовательскиеНастройки",ПолучитьИзВременногоХранилища(АдресПользовательскихНастроек));
		ТекущийОбъект.СтруктураНастроек = Новый ХранилищеЗначения(СтруктураНастроек);
		СтруктураНастроек.Вставить("ПользовательскиеНастройки",Неопределено);
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнятьПартнера 	= Объект.ЗаполнятьПартнера ИЛИ Объект.ЗаполнятьПартнераВТЧ;
	ЗаполнятьСоглашение = Объект.ЗаполнятьСоглашение ИЛИ Объект.ЗаполнятьСоглашениеВТЧ;
	ЗаполнятьСклад 		= Объект.ЗаполнятьСклад ИЛИ Объект.ЗаполнятьСкладВТЧ;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ПриИзмененииТипаПланаВладельца();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПланаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипПлана) Тогда
		Элементы.ПравилоЗаполнения.Доступность = Ложь;
	КонецЕсли;
		
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства") Тогда
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
		Если НЕ ИспользоватьСоглашенияСКлиентами Тогда
			
			ЗаполнятьСоглашение = Ложь;
			Объект.ЗаполнятьСоглашение = Ложь;
			Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
			
		КонецЕсли;
		Если НЕ ПланПродажПланироватьПоСумме Тогда
			Объект.ЗаполнятьПланОплат = Ложь;
		КонецЕсли;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок")  Тогда
		
		Если НЕ ПланЗакупокПланироватьПоСумме Тогда
			Объект.ЗаполнятьПланОплат = Ложь;
		КонецЕсли;
		Объект.ЗаполнятьМенеджера = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланСборкиРазборки") Тогда
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьПодразделение = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродажПоКатегориям") Тогда
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		
	КонецЕсли; 
	
	ПриИзмененииТипаПланаВладельца();
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
	УстановитьВидимостьСтраницФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПартнераПриИзменении(Элемент)
	
	Если ЗаполнятьПартнера И Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Ложь;
		Если ЗаполнятьСоглашение Тогда
			Объект.ЗаполнятьСоглашение = Ложь;
			Объект.ЗаполнятьСоглашениеВТЧ = Истина;
		КонецЕсли; 
	ИначеЕсли ЗаполнятьПартнера И НЕ Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Истина;
	Иначе
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПартнераВТЧПриИзменении(Элемент)
	
	Если ЗаполнятьПартнера И Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Ложь;
		Если ЗаполнятьСоглашение Тогда
		    Объект.ЗаполнятьСоглашениеВТЧ = Истина;
		КонецЕсли; 
		Объект.ЗаполнятьСоглашение = Ложь; 
		Объект.ЗаполнятьПланОплат  = Ложь;
		//++ НЕ УТ
		Объект.ОтражаетсяВБюджетированииОплаты       = Ложь;
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
		//-- НЕ УТ
	ИначеЕсли ЗаполнятьПартнера И НЕ Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Истина;
	Иначе
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСоглашениеПриИзменении(Элемент)
	
	Если ЗаполнятьСоглашение И (Объект.ЗаполнятьПартнераВТЧ ИЛИ Объект.ЗаполнятьСоглашениеВТЧ) Тогда
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Истина;
	ИначеЕсли ЗаполнятьСоглашение И НЕ Объект.ЗаполнятьСоглашениеВТЧ Тогда
		Объект.ЗаполнятьСоглашение = Истина;
	Иначе
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСоглашениеВТЧПриИзменении(Элемент)
	
	Если Объект.ЗаполнятьСоглашениеВТЧ Тогда
		Объект.ЗаполнятьСоглашение = Ложь;
		Если НЕ Объект.ЗаполнятьПартнера Тогда
			Объект.ЗаполнятьПартнераВТЧ = Истина;
		КонецЕсли;
		Объект.ЗаполнятьПланОплат = Ложь;
		//++ НЕ УТ
		Объект.ОтражаетсяВБюджетированииОплаты = Ложь;
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
		//-- НЕ УТ
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСкладПриИзменении(Элемент)
	
	Если ЗаполнятьСклад Тогда
		Объект.ЗаполнятьСклад = Истина;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		ВарианЗаполненияСкладФорматМагазина = 1;
	Иначе
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		ВарианЗаполненияСкладФорматМагазина = 0;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСкладВТЧПриИзменении(Элемент)
	
	Если Объект.ЗаполнятьСкладВТЧ Тогда
		Объект.ЗаполнятьСклад = Ложь;
		ВарианЗаполненияСкладФорматМагазина = 1;
	ИначеЕсли ЗаполнятьСклад Тогда
		Объект.ЗаполнятьСклад = Истина;
		ВарианЗаполненияСкладФорматМагазина = 1;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПоФормулеПриИзменении(Элемент)
	
	Объект.ЗаполнятьПоФормуле = ЗаполнятьПоФормуле;
	
	УстановитьВидимостьСтраницФормы(ЭтотОбъект);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПланОплатПриИзменении(Элемент)
	
	//++ НЕ УТ
	Если НЕ Объект.ЗаполнятьПланОплат Тогда
		Объект.ОтражаетсяВБюджетированииОплаты       = Ложь;
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	//-- НЕ УТ
	
	Возврат; // В УТ 11.1 код данного обработчика пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииОплатыПриИзменении(Элемент)
	
	//++ НЕ УТ
	Если НЕ Объект.ОтражаетсяВБюджетированииОплаты Тогда
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииОплатыПослеОтгрузкиПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВарианЗаполненияСкладФорматМагазинаПриИзменении(Элемент)
	
	Если ВарианЗаполненияСкладФорматМагазина = 1 Тогда
		Объект.ЗаполнятьФорматМагазина = Ложь;
		ЗаполнятьСклад = Истина;
		Объект.ЗаполнятьСклад = Истина;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
	ИначеЕсли ВарианЗаполненияСкладФорматМагазина = 2 Тогда
		Объект.ЗаполнятьФорматМагазина = Истина;
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
	Иначе
		Объект.ЗаполнятьФорматМагазина = Ложь;
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьФорматМагазинаПриИзменении(Элемент)
	
	Если Объект.ЗаполнятьФорматМагазина Тогда
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		ВарианЗаполненияСкладФорматМагазина = 2;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура ПравилоЗаполнения(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли; 
	
	Если Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Оповещение = Новый ОписаниеОповещения("ПравилоЗаполненияВопросЗаписиЗавершение", ЭтотОбъект);
		
		ТекстВопроса = НСтр("ru='Настройки вида плана были изменены. Записать?';uk='Настройки виду плану були змінені. Записати?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Записать';uk='Записати'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		Возврат;
		
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("РежимРедактирования");
	ПараметрыФормы.Вставить("ОбновитьДополнить",      			СтруктураНастроек.ОбновитьДополнить);
	ПараметрыФормы.Вставить("АдресПравилаЗаполнения", 			АдресПравилаЗаполнения);
	ПараметрыФормы.Вставить("ИзменитьРезультатНа",    			СтруктураНастроек.ИзменитьРезультатНа);
	ПараметрыФормы.Вставить("ТочностьОкругления",     			СтруктураНастроек.ТочностьОкругления);
	ПараметрыФормы.Вставить("Периодичность",            		Периодичность);
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
		ПараметрыФормы.Вставить("ПланироватьПоСумме", 			ПланЗакупокПланироватьПоСумме);
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
		ПараметрыФормы.Вставить("ПланироватьПоСумме",			ПланПродажПланироватьПоСумме);
	Иначе
		ПараметрыФормы.Вставить("ПланироватьПоСумме",          	Ложь);
	КонецЕсли;
	ПараметрыФормы.Вставить("ВидПлана",                         Объект.Ссылка);
	ПараметрыФормы.Вставить("АдресПользовательскихНастроек",    АдресПользовательскихНастроек);
	ПараметрыФормы.Вставить("ТолькоПросмотр",                   ЭтаФорма.ТолькоПросмотр);
	
	Оповещение = Новый ОписаниеОповещения("ПравилоЗаполненияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ИсточникиДанныхПланирования.Форма.ФормаЗаполнения", 
		ПараметрыФормы, 
		ЭтаФорма, 
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииТипаПланаВладельца()
	
	Реквизиты = ПолучитьРеквизитыВладельцаСервер(Объект.Владелец, Объект.ТипПлана);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Реквизиты);
	//++ НЕ УТ
	Объект.ОтражаетсяВБюджетировании = ОтражаетсяВБюджетировании;
	Объект.ОтражаетсяВБюджетированииОплаты = ОтражаетсяВБюджетировании И Объект.ЗаполнятьПланОплат;
	Если Не Объект.ОтражаетсяВБюджетированииОплаты Тогда
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
	КонецЕсли; 
	ОтражаетсяВБюджетированииПриИзменении(Неопределено);
	//-- НЕ УТ
	
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыВладельцаСервер(Знач Сценарий, Знач ТипПлана)
	
	Реквизиты = "Периодичность, ПланЗакупокПланироватьПоСумме, ПланПродажПланироватьПоСумме";
	//++ НЕ УТ
	Реквизиты = Реквизиты + ", ОтражаетсяВБюджетировании";
	//-- НЕ УТ
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, Реквизиты);
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьСтраницФормы(Форма)
	
	ТипПлана = Форма.Объект.ТипПлана;
	
	Если Форма.Объект.ЗаполнятьПоФормуле Тогда
		
		Если Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродажПоКатегориям") Тогда
			
			Форма.Элементы.ГруппаПланыИспользования.ТекущаяСтраница = Форма.Элементы.ГруппаПростойВариантЗаполненияПодажиПоКатегориям;
			
		ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
			
			Форма.Элементы.ГруппаПланыИспользования.ТекущаяСтраница = Форма.Элементы.ГруппаПростойВариантЗаполненияПродажи;
			
		ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланСборкиРазборки") Тогда
			
			Форма.Элементы.ГруппаПланыИспользования.ТекущаяСтраница = Форма.Элементы.ГруппаПростойВариантЗаполненияСборка;
			
		ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства") Тогда
			
			Форма.Элементы.ГруппаПланыИспользования.ТекущаяСтраница = Форма.Элементы.ГруппаПростойВариантЗаполненияПроизводство;
			
		ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
			
			Форма.Элементы.ГруппаПланыИспользования.ТекущаяСтраница = Форма.Элементы.ГруппаПростойВариантЗаполненияЗакупки;
			
		КонецЕсли;
		
	Иначе
		Форма.Элементы.ГруппаПланыИспользования.ТекущаяСтраница = Форма.Элементы.ГруппаРасширенныйВариантЗаполнения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоЗаполненияЗавершение(Настройки, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		
		Модифицированность = Истина;
		
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, Настройки, "ОбновитьДополнить,ИзменитьРезультатНа,ТочностьОкругления");
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Сохранение настроек в виде плана завершено';uk='Збереження настройок у вигляді плану завершено'"),
			,
			,
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоЗаполненияВопросЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Записать();
		ПравилоЗаполнения(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	Если ЗначениеЗаполнено(Объект.ТипПлана) И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ТипПлана.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	ИспользоватьСоглашенияСКлиентами    = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	ИспользоватьСоглашенияСПоставщиками = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками");
	
	Элементы.ЗаполнятьСоглашениеПродажи.Видимость = ИспользоватьСоглашенияСКлиентами;
	
	Реквизиты = ПолучитьРеквизитыВладельцаСервер(Объект.Владелец, Объект.ТипПлана);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Реквизиты);
	
	СтруктураНастроек = Новый Структура("ОбновитьДополнить, ИзменитьРезультатНа, ТочностьОкругления", 0, 0, 0);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		//++ НЕ УТ
		Если ЭтаФорма.ОтражаетсяВБюджетировании Тогда
			Объект.ОтражаетсяВБюджетировании = Истина;
		КонецЕсли;
		//-- НЕ УТ
	
	КонецЕсли;
	Если НЕ ЭтоАдресВременногоХранилища(АдресПравилаЗаполнения) Тогда		
		// Копированием
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			АдресПравилаЗаполнения = ПоместитьВоВременноеХранилище(
				Параметры.ЗначениеКопирования.ПравилоЗаполнения.Выгрузить(),
				УникальныйИдентификатор);
		Иначе
			СценарийОбъект = РеквизитФормыВЗначение("Объект");
			
			АдресПравилаЗаполнения = ПоместитьВоВременноеХранилище(
				СценарийОбъект.ПравилоЗаполнения.Выгрузить(),
				УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресПользовательскихНастроек) Тогда
		// Копированием
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			
			СтруктураНастроекКопирования = Параметры.ЗначениеКопирования.СтруктураНастроек.Получить();
			Если ТипЗнч(СтруктураНастроекКопирования) = Тип("Структура") Тогда
				ЗаполнитьЗначенияСвойств(СтруктураНастроек, СтруктураНастроекКопирования);
			КонецЕсли;
			Если ТипЗнч(СтруктураНастроекКопирования) = Тип("Структура") И СтруктураНастроекКопирования.Свойство("ПользовательскиеНастройки") Тогда
				АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(СтруктураНастроекКопирования.ПользовательскиеНастройки, УникальныйИдентификатор);
			Иначе
				АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
			КонецЕсли; 
		Иначе
			АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнятьПартнера   = Объект.ЗаполнятьПартнера ИЛИ Объект.ЗаполнятьПартнераВТЧ;
	ЗаполнятьСоглашение = Объект.ЗаполнятьСоглашение ИЛИ Объект.ЗаполнятьСоглашениеВТЧ;
	ЗаполнятьСклад      = Объект.ЗаполнятьСклад ИЛИ Объект.ЗаполнятьСкладВТЧ;
	ЗаполнятьПоФормуле  = Объект.ЗаполнятьПоФормуле;
	
	Если ЗаполнятьСклад Тогда
		ВарианЗаполненияСкладФорматМагазина = 1;
	ИначеЕсли Объект.ЗаполнятьФорматМагазина Тогда
		ВарианЗаполненияСкладФорматМагазина = 2;
	Иначе
		ВарианЗаполненияСкладФорматМагазина = 0;
	КонецЕсли; 
	
	УстановитьВидимостьСтраницФормы(ЭтаФорма);
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
	Элементы.ЗаполнятьСоглашениеЗакупки.Видимость = ИспользоватьСоглашенияСПоставщиками;
	Элементы.ЗаполнятьСоглашениеПродажи.Видимость = ИспользоватьСоглашенияСКлиентами;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьЭлементов(Форма)
	
	//++ НЕ УТ
	Форма.Элементы.ОтражаетсяВБюджетировании.Доступность = Форма.ОтражаетсяВБюджетировании;
	Форма.Элементы.СтатьяБюджетов.Доступность = Форма.Объект.ОтражаетсяВБюджетировании;
	Форма.Элементы.СтатьяБюджетов.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетировании;
	Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Доступность = Форма.ОтражаетсяВБюджетировании И Форма.Объект.ЗаполнятьПланОплат;
	Форма.Элементы.СтатьяБюджетовОплат.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
	Форма.Элементы.СтатьяБюджетовОплат.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
	Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
	Форма.Элементы.СтатьяБюджетовОплатКредит.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит;
	Форма.Элементы.СтатьяБюджетовОплатКредит.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит;
	//-- НЕ УТ
	
	Форма.Элементы.ЗаполнятьПодразделение.Доступность = Истина;
	Форма.Элементы.ЗаполнятьПартнера.Доступность = Истина;
	Форма.Элементы.ЗаполнятьПартнераВТЧ.Доступность = Форма.ЗаполнятьПартнера;
	Форма.Элементы.ЗаполнятьСоглашение.Доступность = Форма.ЗаполнятьПартнера;
	Форма.Элементы.ЗаполнятьСоглашениеВТЧ.Доступность = Форма.ЗаполнятьПартнера и Форма.ЗаполнятьСоглашение;
	Форма.Элементы.ЗаполнятьСклад.Доступность = Истина;
	Форма.Элементы.ЗаполнятьСкладВТЧ.Доступность = Форма.ЗаполнятьСклад;
	Форма.Элементы.ЗаполнятьМенеджера.Доступность = Истина;
	Форма.Элементы.ЗаполнятьФорматМагазина.Доступность = Истина;
	
	Если Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства") Тогда
		
		Форма.Элементы.ЗаполнятьПартнера.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПартнераВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашение.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашениеВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСклад.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСкладВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПланОплат.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьМенеджера.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьФорматМагазина.Доступность = Ложь;
		//++ НЕ УТ
		Форма.Элементы.ОтражаетсяВБюджетированииПроизводство.Доступность = Форма.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовПроизводство.Доступность = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовПроизводство.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru='План производства:';uk='План виробництва:'");
		Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = НСтр("ru='Оплаты:';uk='Оплати:'");
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru='Выделять оплаты (после отгрузки):';uk='Виділяти оплати (після відвантаження):'");
		//-- НЕ УТ
		
	ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
		
		Если Не Форма.ИспользоватьСоглашенияСКлиентами Тогда
			
			Форма.Элементы.ЗаполнятьСоглашение.Доступность = Ложь;
			Форма.Элементы.ЗаполнятьСоглашениеВТЧ.Доступность = Ложь;
			
		КонецЕсли;
		
		Форма.Элементы.ЗаполнятьСоглашениеПродажи.Доступность = Форма.ЗаполнятьПартнера;
		Форма.Элементы.ЗаполнятьПланОплатПродажи.Доступность = Форма.ПланПродажПланироватьПоСумме;
		Форма.Элементы.ЗаполнятьПланОплат.Доступность = Форма.ПланПродажПланироватьПоСумме 
			И НЕ Форма.Объект.ЗаполнятьПартнераВТЧ И НЕ Форма.Объект.ЗаполнятьСоглашениеВТЧ;
		Форма.Элементы.ЗаполнятьМенеджера.Доступность = Истина;
		//++ НЕ УТ
		Форма.Элементы.ОтражаетсяВБюджетированииПродажи.Доступность = Форма.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовПродажи.Доступность = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовПродажи.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыПродажи.Доступность = Форма.ОтражаетсяВБюджетировании И Форма.Объект.ЗаполнятьПланОплат;
		Форма.Элементы.СтатьяБюджетовОплатПродажи.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
		Форма.Элементы.СтатьяБюджетовОплатПродажи.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредитПродажи.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
		Форма.Элементы.СтатьяБюджетовОплатКредитПродажи.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит;
		Форма.Элементы.СтатьяБюджетовОплатКредитПродажи.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит;
		Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru='Продажи:';uk='Продажі:'");
		ЗаголовокФлагаОплат = ?(Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит,
				НСтр("ru='Оплаты (до отгрузки):';uk='Оплати (до відвантаження):'"),
				НСтр("ru='Оплаты:';uk='Оплати:'"));
		Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = ЗаголовокФлагаОплат;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыПродажи.Заголовок = ЗаголовокФлагаОплат;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru='Выделять оплаты (после отгрузки):';uk='Виділяти оплати (після відвантаження):'");
		//-- НЕ УТ
		
	ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродажПоКатегориям") Тогда
		
		Форма.Элементы.ЗаполнятьПартнера.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПартнераВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашение.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашениеВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСкладВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПланОплат.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьМенеджера.Доступность = Ложь;
		//++ НЕ УТ
		Форма.Элементы.ОтражаетсяВБюджетированииПродажиПоКатегориям.Доступность = Форма.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовПродажиПоКатегориям.Доступность = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовПродажиПоКатегориям.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru='Продажи:';uk='Продажі:'");
		Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = НСтр("ru='Оплаты:';uk='Оплати:'");
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru='Выделять оплаты (после отгрузки):';uk='Виділяти оплати (після відвантаження):'");
		//-- НЕ УТ
		
	ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
		
		Форма.Элементы.ЗаполнятьПланОплатЗакупки.Доступность = Форма.ПланЗакупокПланироватьПоСумме;
		Форма.Элементы.ЗаполнятьПланОплат.Доступность = Форма.ПланЗакупокПланироватьПоСумме
			И НЕ Форма.Объект.ЗаполнятьПартнераВТЧ И НЕ Форма.Объект.ЗаполнятьСоглашениеВТЧ;
		Форма.Элементы.ЗаполнятьМенеджера.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьФорматМагазина.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашениеЗакупки.Доступность = Форма.ЗаполнятьПартнера;
		//++ НЕ УТ
		Форма.Элементы.ОтражаетсяВБюджетированииЗакупки.Доступность = Форма.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовЗакупки.Доступность = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовЗакупки.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыЗакупки.Доступность = Форма.ОтражаетсяВБюджетировании И Форма.Объект.ЗаполнятьПланОплат;
		Форма.Элементы.СтатьяБюджетовОплатЗакупки.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
		Форма.Элементы.СтатьяБюджетовОплатЗакупки.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредитЗакупки.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплаты;
		Форма.Элементы.СтатьяБюджетовОплатКредитЗакупки.Доступность = Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит;
		Форма.Элементы.СтатьяБюджетовОплатКредитЗакупки.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит;
		Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru='Закупки:';uk='Купівлі:'");
		ЗаголовокФлагаОплат = ?(Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит,
				НСтр("ru='Оплаты (до поступления):';uk='Оплати (до надходження):'"),
				НСтр("ru='Оплаты:';uk='Оплати:'"));
		Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = ЗаголовокФлагаОплат;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыЗакупки.Заголовок = ЗаголовокФлагаОплат;
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru='Выделять оплаты (после поступления):';uk='Виділяти оплати (після надходження):'");
		//-- НЕ УТ
		
	ИначеЕсли Форма.Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланСборкиРазборки") Тогда
		
		Форма.Элементы.ЗаполнятьПодразделение.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПартнера.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПартнераВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашение.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьСоглашениеВТЧ.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьПланОплат.Доступность = Ложь; 
		Форма.Элементы.ЗаполнятьМенеджера.Доступность = Ложь;
		Форма.Элементы.ЗаполнятьФорматМагазина.Доступность = Ложь;
		//++ НЕ УТ
		Форма.Элементы.ОтражаетсяВБюджетированииСборка.Доступность = Форма.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовСборка.Доступность = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.СтатьяБюджетовСборка.АвтоОтметкаНезаполненного = Форма.Объект.ОтражаетсяВБюджетировании;
		Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru='План сборки (разборки):';uk='План збирання (розбирання):'");
		Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = НСтр("ru='Оплаты:';uk='Оплати:'");
		Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru='Выделять оплаты (после отгрузки):';uk='Виділяти оплати (після відвантаження):'");
		//-- НЕ УТ
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
