#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();

	ДокументРезультат.Очистить();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();				   
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	Если КлючВарианта = "ГрафикОтпусков" Тогда
		
		Попытка
			
			СтандартнаяОбработка = Ложь;
			
			// Параметры документа
			ДокументРезультат.ТолькоПросмотр = Истина;
			ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ГрафикОтпусков";
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			
			ВосстанавливатьПериод = Ложь;
			Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ВосстанавливатьПериод", ВосстанавливатьПериод) И ВосстанавливатьПериод Тогда
				ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
				ПереданныйПараметрПериод = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
				ПараметрПериод.Значение = ПереданныйПараметрПериод.Значение;
			КонецЕсли;
			
			ПроверитьЗначенияПараметров(НастройкиОтчета, Истина);
			
			Данные = Новый ДеревоЗначений;
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			// Создадим и инициализируем процессор компоновки.
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(Данные);
			
			// Обозначим начало вывода
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
			ВывестиМакет(ДокументРезультат, Данные);
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru='В настройку отчета внесены критичные изменения. Отчет не будет сформирован.';uk='У настройку звіту внесені критичні зміни. Звіт не буде сформований.'") + " " + Инфо.Описание;
		КонецПопытки;
		
	Иначе
		
		ПроверитьЗначенияПараметров(НастройкиОтчета);
		
		СтандартнаяОбработка = ложь;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
		
		// Создадим и инициализируем процессор компоновки.
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		
		// Обозначим начало вывода
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
	КонецЕсли;
	
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

Процедура ВывестиМакет(ДокументРезультат, Данные)
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ТекущийЛист = Новый ТабличныйДокумент;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ГрафикОтпусков.ПФ_MXL_ГрафикОтпусков"); 	
		
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПовторятьПриПечати = Макет.ПолучитьОбласть("ПовторятьПриПечати");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаРаботник");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Для Каждого ДанныеПоОрганизации Из Данные.Строки Цикл
		
		Для Каждого ДанныеПоГоду Из ДанныеПоОрганизации.Строки Цикл
			
			ДанныеПодписантов = СведенияОПодписантах(ДанныеПоОрганизации.Организация, Дата(ДанныеПоГоду.ГодГрафика, 12, 31));
			
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				ДокументРезультат.Вывести(ТекущийЛист);
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ТекущийЛист = Новый ТабличныйДокумент;
			КонецЕсли;
			
			ЗаполнитьШапкуИПодвал(ОбластьШапка, ОбластьПодвал, ДанныеПоГоду, ДанныеПодписантов);
			
			ВывестиОбласть(ДокументРезультат, ТекущийЛист, ОбластьШапка, ОбластьШапка);	
			
			Для Каждого ДанныеПоСотруднику Из ДанныеПоГоду.Строки Цикл
				ВывестиДанныеПоСотруднику(ДокументРезультат, ТекущийЛист, ОбластьСтрока, ДанныеПоСотруднику, ОбластьПовторятьПриПечати, ОбластьПодвал);		
			КонецЦикла;	
			
			ВывестиОбласть(ДокументРезультат, ТекущийЛист, ОбластьПодвал, ОбластьПодвал);	
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если ТекущийЛист.ВысотаТаблицы > 0 Тогда
		ДокументРезультат.Вывести(ТекущийЛист);
	КонецЕсли;
	
КонецПроцедуры	

Процедура ЗаполнитьШапкуИПодвал(ОбластьШапка, ОбластьПодвал, Данные, ДанныеПодписантов)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ОбластьШапка.Параметры.Заполнить(Данные);
	ОбластьШапка.Параметры.Заполнить(ДанныеПодписантов);
	ОбластьПодвал.Параметры.Заполнить(ДанныеПодписантов);
	
	Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
		ОбластьШапка.Параметры.ПараметрыДанныхНомерДок = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ОбластьШапка.Параметры.ПараметрыДанныхНомерДок, Истина, Истина);
	КонецЕсли; 
		
КонецПроцедуры	

Процедура ВывестиДанныеПоСотруднику(ДокументРезультат, ТекущийЛист, ОбластьСтрока, ДанныеПоСотруднику, ОбластьПовторятьПриПечати, ОбластьПодвал)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	КоличествоПараметров = ОбластьСтрока.Параметры.Количество();
	
	Для ИндексПараметра = 0 По КоличествоПараметров - 1 Цикл  
		ОбластьСтрока.Параметры.Установить(ИндексПараметра, Неопределено);
	КонецЦикла;
	
	ОбластьСтрока.Параметры.Заполнить(ДанныеПоСотруднику);
	Если ЗначениеЗаполнено(ДанныеПоСотруднику.ПеренесеннаяДатаНачала) И ЗначениеЗаполнено(ДанныеПоСотруднику.ДокументПереноса) Тогда
		ОбластьСтрока.Параметры.ОснованиеПереноса = ?(ДанныеПоСотруднику.ДокументПереносаПереносПоИнициативеСотрудника,"Заявление","Предложение") + " от " + Формат(ДанныеПоСотруднику.ДокументПереносаДата, "ДЛФ=D") + " № " + ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(ДанныеПоСотруднику.ДокументПереносаНомер, Истина, Истина)
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеПоСотруднику.ВидОтпуска) И ДанныеПоСотруднику.ВидОтпуска <> ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Основной") Тогда
		ОбластьСтрока.Параметры.Примечание = "Доп.отпуск: " + ДанныеПоСотруднику.ВидОтпускаНаименование	
	КонецЕсли;
	
	Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ДанныеПоСотруднику.Подразделение) Тогда
		ОбластьСтрока.Параметры.ПодразделениеНаименование = ДанныеПоСотруднику.Подразделение.ПолноеНаименование();
	КонецЕсли;
	
	ПроверяемыеОбласти = Новый Массив;
	ПроверяемыеОбласти.Добавить(ОбластьСтрока);
	ПроверяемыеОбласти.Добавить(ОбластьПодвал);
	ВывестиОбласть(ДокументРезультат, ТекущийЛист, ОбластьСтрока, ПроверяемыеОбласти, ОбластьПовторятьПриПечати);
	
КонецПроцедуры	

Процедура ВывестиОбласть(ДокументРезультат, ТекущийЛист, ВыводимаяОбласть, ПроверяемыеОбласти, ОбластьПовторятьПриПечати = Неопределено)
	
	ТекущийЛист.ОриентацияСтраницы = ДокументРезультат.ОриентацияСтраницы;
	ТекущийЛист.АвтоМасштаб = ДокументРезультат.АвтоМасштаб;
	
	Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТекущийЛист, ПроверяемыеОбласти) Тогда
		ТекущийЛист.ВывестиГоризонтальныйРазделительСтраниц();
		ДокументРезультат.Вывести(ТекущийЛист);
		ТекущийЛист = Новый ТабличныйДокумент;
		Если ОбластьПовторятьПриПечати <> Неопределено Тогда
			ТекущийЛист.Вывести(ОбластьПовторятьПриПечати);
		КонецЕсли;
	КонецЕсли;
	
	ТекущийЛист.Вывести(ВыводимаяОбласть);
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// Универсальные процедуры и Функции.

Процедура ПроверитьЗначенияПараметров(НастройкиОтчета, ВыводитьПодписантов = Ложь)
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	Если ПараметрПериод <> Неопределено Тогда
		НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
		КонецПериода = ПараметрПериод.Значение.ДатаОкончания;
		
		ПараметрПериод.Использование = Истина;
	Иначе
		НачалоПериода = НачалоГода(ТекущаяДатаСеанса());
		КонецПериода = КонецГода(ТекущаяДатаСеанса());
		
		ПараметрПериод = НастройкиОтчета.ПараметрыДанных.Элементы.Добавить();
		ПараметрПериод.Значение = Новый СтандартныйПериод;
		ПараметрПериод.Значение.ДатаНачала = НачалоПериода;
		ПараметрПериод.Значение.ДатаОкончания = КонецПериода;
		ПараметрПериод.Использование = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НомерДок"));
	Если ЗначениеПараметра <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
			ЗначениеПараметра.Использование = Ложь;
		КонецЕсли;
	КонецЕсли;
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаДок"));
	Если ЗначениеПараметра <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
			ЗначениеПараметра.Использование = ЗначениеЗаполнено(ЗначениеПараметра.Значение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СведенияОПодписантах(Организация, ДатаОтчета)
	
	ПараметрыЗаполнения = Новый Структура("Руководитель,РуководительРасшифровкаПодписи,ДолжностьРуководителя,"
		+ "РуководительКадровойСлужбы,РуководительКадровойСлужбыРасшифровкаПодписи,ДолжностьРуководителяКадровойСлужбы");
		
	КлючиОтветственныхЛиц = "";

	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("Руководитель", ПараметрыЗаполнения.Руководитель);
	Если НЕ ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
		
		ПараметрРуководитель = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Руководитель"));	
		Если ПараметрРуководитель <> Неопределено И ПараметрРуководитель.Использование Тогда
			Если ЗначениеЗаполнено(ПараметрРуководитель.Значение) Тогда
				ПараметрыЗаполнения.Руководитель = ПараметрРуководитель.Значение;
			КонецЕсли; 
		Иначе
			КлючиОтветственныхЛиц = "Руководитель";
		КонецЕсли;

	КонецЕсли;
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДолжностьРуководителя", ПараметрыЗаполнения.ДолжностьРуководителя);
	Если НЕ ЗначениеЗаполнено(ПараметрыЗаполнения.ДолжностьРуководителя) Тогда
		
		ПараметрДолжностьРуководителя = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДолжностьРуководителя"));	
		Если ПараметрДолжностьРуководителя <> Неопределено И ПараметрДолжностьРуководителя.Использование Тогда
			ПараметрыЗаполнения.ДолжностьРуководителя = ПараметрДолжностьРуководителя.Значение;
		Иначе
			КлючиОтветственныхЛиц = ?(ПустаяСтрока(КлючиОтветственныхЛиц), "", КлючиОтветственныхЛиц + ",") + "ДолжностьРуководителяСтрокой";
		КонецЕсли;
		
	КонецЕсли; 
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("РуководительКадровойСлужбы", ПараметрыЗаполнения.РуководительКадровойСлужбы);
	Если НЕ ЗначениеЗаполнено(ПараметрыЗаполнения.РуководительКадровойСлужбы) Тогда
		
		ПараметрРуководительКадровойСлужбы = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("РуководительКадровойСлужбы"));	
		Если ПараметрРуководительКадровойСлужбы <> Неопределено И ПараметрРуководительКадровойСлужбы.Использование Тогда
			Если ЗначениеЗаполнено(ПараметрРуководительКадровойСлужбы.Значение) Тогда
				ПараметрыЗаполнения.РуководительКадровойСлужбы = ПараметрРуководительКадровойСлужбы.Значение;
			КонецЕсли; 
		Иначе
			КлючиОтветственныхЛиц = ?(ПустаяСтрока(КлючиОтветственныхЛиц), "", КлючиОтветственныхЛиц + ",") + "РуководительКадровойСлужбы";
		КонецЕсли;

	КонецЕсли;
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДолжностьРуководителяКадровойСлужбы", ПараметрыЗаполнения.ДолжностьРуководителяКадровойСлужбы);
	Если НЕ ЗначениеЗаполнено(ПараметрыЗаполнения.ДолжностьРуководителяКадровойСлужбы) Тогда
		
		ПараметрДолжностьРуководителяКадровойСлужбы = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДолжностьРуководителяКадровойСлужбы"));	
		Если ПараметрДолжностьРуководителяКадровойСлужбы <> Неопределено И ПараметрДолжностьРуководителяКадровойСлужбы.Использование Тогда
			ПараметрыЗаполнения.ДолжностьРуководителяКадровойСлужбы = ПараметрДолжностьРуководителяКадровойСлужбы.Значение;
		Иначе
			КлючиОтветственныхЛиц = ?(ПустаяСтрока(КлючиОтветственныхЛиц), "", КлючиОтветственныхЛиц + ",") + "ДолжностьРуководителяКадровойСлужбыСтрокой";
		КонецЕсли;
		
	КонецЕсли; 
	
	Если Не ПустаяСтрока(КлючиОтветственныхЛиц) Тогда
		
		ОтветственныеЛица = Новый Структура("Организация," + КлючиОтветственныхЛиц, Организация);
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ОтветственныеЛица, ДатаОтчета);
		
		ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ОтветственныеЛица);
		
		Если ОтветственныеЛица.Свойство("ДолжностьРуководителяСтрокой")
			И ЗначениеЗаполнено(ОтветственныеЛица.ДолжностьРуководителяСтрокой) Тогда
			
			ПараметрыЗаполнения.ДолжностьРуководителя = ОтветственныеЛица.ДолжностьРуководителяСтрокой;
			
		КонецЕсли; 
		
		Если ОтветственныеЛица.Свойство("ДолжностьРуководителяКадровойСлужбыСтрокой")
			И ЗначениеЗаполнено(ОтветственныеЛица.ДолжностьРуководителяКадровойСлужбыСтрокой) Тогда
			
			ПараметрыЗаполнения.ДолжностьРуководителяКадровойСлужбы = ОтветственныеЛица.ДолжностьРуководителяКадровойСлужбыСтрокой;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	МассивФизЛиц = Новый Массив;
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Руководитель);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.РуководительКадровойСлужбы) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.РуководительКадровойСлужбы);
	КонецЕсли; 
		
	Если МассивФизЛиц.Количество() > 0 Тогда
		
		ФИОФизЛиц = ЗарплатаКадры.СоответствиеФИОФизЛицСсылкам(ДатаОтчета, МассивФизЛиц);
		
		Если ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
			ПараметрыЗаполнения.РуководительРасшифровкаПодписи = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИОФизЛиц[ПараметрыЗаполнения.Руководитель]);
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ПараметрыЗаполнения.РуководительКадровойСлужбы) Тогда
			ПараметрыЗаполнения.РуководительКадровойСлужбыРасшифровкаПодписи = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИОФизЛиц[ПараметрыЗаполнения.РуководительКадровойСлужбы]);
		КонецЕсли; 

	КонецЕсли; 
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецЕсли