#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	Если Не КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта") Тогда
		КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	КонецЕсли;
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Перем КоличествоДокументов;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КлючТекущегоВарианта = Неопределено;
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта", КлючТекущегоВарианта);
	Если КлючТекущегоВарианта = "РезультатРаботыПравилПоСтатьямБюджетов" 
		Или КлючТекущегоВарианта = "РезультатРаботыПравилПоСтатьеБюджетов" Тогда
		ПолучитьФактПоСтатьямБюджетов = Истина;
		ПолучитьФактПоПоказателямБюджетов = Ложь;
	ИначеЕсли КлючТекущегоВарианта = "РезультатРаботыПравилПоПоказателямБюджетов"
		Или КлючТекущегоВарианта = "РезультатРаботыПравилПоПоказателюБюджетов" Тогда
		ПолучитьФактПоСтатьямБюджетов = Ложь;
		ПолучитьФактПоПоказателямБюджетов = Истина;
	Иначе
		ПолучитьФактПоСтатьямБюджетов = Истина;
		ПолучитьФактПоПоказателямБюджетов = Истина;
	КонецЕсли;
	
	ПараметрыПолученияФакта = ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета);
	Если ПолучитьФактПоСтатьямБюджетов Тогда
		ФактПоСтатьямБюджетов = БюджетированиеСервер.ФактПоСтатьямБюджетов(НастройкиОтчета, ПараметрыПолученияФакта);
	Иначе
		ФактПоСтатьямБюджетов = Новый ТаблицаЗначений;
	КонецЕсли;
	Если ПолучитьФактПоПоказателямБюджетов Тогда
		ФактПоПоказателямБюджетов = БюджетированиеСервер.ФактПоПоказателямБюджетов(НастройкиОтчета, ПараметрыПолученияФакта);
	Иначе
		ФактПоПоказателямБюджетов = Новый ТаблицаЗначений;
	КонецЕсли;
	
	Аналитика = Новый ТаблицаЗначений;
	Для каждого Поле Из СхемаКомпоновкиДанных.НаборыДанных.Найти("Аналитика").Поля Цикл
		Аналитика.Колонки.Добавить(Поле.Поле, Поле.ТипЗначения);
	КонецЦикла;
	
	НастроитьДополнениеПериода(НастройкиОтчета);
	
	Для каждого ЭлементСтруктуры Из НастройкиОтчета.Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
			ФинансоваяОтчетностьСервер.СкопироватьОтбор(НастройкиОтчета.Отбор, ЭлементСтруктуры.Настройки.Отбор, Истина);
			Для каждого Параметр Из НастройкиОтчета.ПараметрыДанных.Элементы Цикл
				ЗначениеПараметра =  ЭлементСтруктуры.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Параметр.Параметр);
				Если ЗначениеПараметра <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(ЗначениеПараметра, Параметр);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	//++ НЕ УТКА
	#Область ЗапускФоновогоОтраженияДокументовВБюджетировании
		Период = БюджетированиеСервер.ЗначениеНастройкиСКД(КомпоновщикНастроек, "Период");
		НачалоПериода = Период.ДатаНачала;
		КонецПериода = Период.ДатаОкончания;
		ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		
		ДопСвойства.Удалить("КоличествоДокументовКОтражениюВБюджетировании");
		Если РегистрыСведений.ЗаданияКОтражениюВБюджетировании.ТребуетсяОтражениеВБюджетированииДляОтчетаЗаПериод(
																	НачалоПериода, КонецПериода, КоличествоДокументов) Тогда
			
			ФактическиеДанныеБюджетированияСервер.ОтразитьДокументыФоновымЗаданием(НачалоПериода, КонецПериода);
			ДопСвойства.Вставить("КоличествоДокументовКОтражениюВБюджетировании", КоличествоДокументов);
			ДопСвойства.Вставить("НачалоПериода", НачалоПериода);
			ДопСвойства.Вставить("КонецПериода", КонецПериода);
			
		КонецЕсли;
	#КонецОбласти
	//-- НЕ УТКА
	
	ВнешниеНаборы = Новый Структура;
	ВнешниеНаборы.Вставить("ФактПоСтатьямБюджетов", ФактПоСтатьямБюджетов);
	ВнешниеНаборы.Вставить("ФактПоПоказателямБюджетов", ФактПоПоказателямБюджетов);
	ВнешниеНаборы.Вставить("Аналитика", Аналитика);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборы, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	//++ НЕ УТКА
	ФактическиеДанныеБюджетированияСервер.ВывестиАктуальностьОтраженияФактическихДанных(ДокументРезультат, ДопСвойства);
	//-- НЕ УТКА
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыПолученияФактаПоНастройкамОтчета(НастройкиОтчета)
	
	Параметры = БюджетированиеСервер.ПараметрыПолученияФакта();
	
	Параметры.ВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Валюта").Значение;
	Параметры.Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение; 
	Параметры.Периодичность = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Периодичность").Значение;
	Параметры.ВозвращатьПравилоПолученияДанных = Истина;
	Параметры.ПоОрганизациям = Истина;
	Параметры.ПоПодразделениям = Истина;
	
	Показатели = Новый Структура;
	Для каждого ЭлементСтруктуры Из НастройкиОтчета.Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) <> Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(ЭлементСтруктуры.Настройки, "Регистратор") Тогда
			Параметры.РазворачиватьПоРегистратору = Истина;
		КонецЕсли;
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(ЭлементСтруктуры.Настройки, "Сумма") Тогда
			Показатели.Вставить("Сумма");
		КонецЕсли;
		Если КомпоновкаДанныхКлиентСервер.ПолеИспользуется(ЭлементСтруктуры.Настройки, "Количество") Тогда
			Показатели.Вставить("Количество");
		КонецЕсли;
	КонецЦикла;
	
	Параметры.Показатели = Показатели;
	
	Возврат Параметры; 
	
КонецФункции

Процедура НастроитьДополнениеПериода(НастройкиОтчета) 
	
	Перидичность = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Периодичность").Значение;
	СтрокаПериодичность = ОбщегоНазначения.ИмяЗначенияПеречисления(Перидичность);
	ТипДополнения = ТипДополненияПериодаКомпоновкиДанных[СтрокаПериодичность];
	
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период").Значение;
	ПолеПериод = Новый ПолеКомпоновкиДанных("Период");
	
	Для каждого ЭлементСтруктуры Из НастройкиОтчета.Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) <> Тип("НастройкиВложенногоОбъектаКомпоновкиДанных")  Тогда
			Продолжить;
		КонецЕсли;
		Группировки = КомпоновкаДанныхКлиентСервер.ПолучитьГруппировки(ЭлементСтруктуры.Настройки);
		Для каждого Группировка Из Группировки Цикл
			ЭлементыГруппировки = Группировка.Значение.ПоляГруппировки.Элементы;
			Если ЭлементыГруппировки.Количество() = 1 И ЭлементыГруппировки[0].Поле = ПолеПериод Тогда
				ГруппировкаПериод = ЭлементыГруппировки[0];
				ГруппировкаПериод.ТипДополнения = ТипДополнения;
				ГруппировкаПериод.НачалоПериода = Период.ДатаНачала;
				ГруппировкаПериод.КонецПериода = Период.ДатаОкончания;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	Если ПараметрВалюта <> Неопределено И Не ЗначениеЗаполнено(ПараметрВалюта.Значение) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, "Валюта", Константы.ВалютаУправленческогоУчета.Получить());
		ПользовательскиеНастройкиМодифицированы = Истина;
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
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ПараметрыОтчет")
			И Параметры.ПараметрыОтчет.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "ПоСтатьеБюджетов" Тогда
			Если ТипЗнч(Параметры.ПараметрКоманды) = Тип("СправочникСсылка.ПравилаПолученияФактаПоСтатьямБюджетов") Тогда
				СтатьяБюджетов = Параметры.ПараметрКоманды.СтатьяБюджетов;
			Иначе
				СтатьяБюджетов = Параметры.ПараметрКоманды;
			КонецЕсли;
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("СтатьяБюджетов", СтатьяБюджетов);
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "ПоПоказателюБюджетов" Тогда
			Если ТипЗнч(Параметры.ПараметрКоманды) = Тип("СправочникСсылка.ПравилаПолученияФактаПоПоказателямБюджетов") Тогда
				ПоказательБюджетов = Параметры.ПараметрКоманды.ПоказательБюджетов;
			Иначе
				ПоказательБюджетов = Параметры.ПараметрКоманды;
			КонецЕсли;
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ПоказательБюджетов", ПоказательБюджетов);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли



