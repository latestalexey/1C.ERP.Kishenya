#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ВыводитьСуммуВыделенныхЯчеек = Ложь;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
	Настройки.Вставить("РазрешеноМенятьВарианты", Ложь);
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПослеЗаполненияПанелиБыстрыхНастроек
//
Процедура ПослеЗаполненияПанелиБыстрыхНастроек(ЭтаФорма, ПараметрыЗаполнения) Экспорт
	
	Счет             = ДанныеПараметра(ЭтаФорма, "СчетПланаСчетов");
	ЭтоМеждународный = ДанныеПараметра(ЭтаФорма, "ПланСчетов");
	Если ЭтоМеждународный.Значение = Неопределено Тогда
		ЭтоМеждународный.Значение = Истина;
	КонецЕсли;
	ВидСубконто      = ДанныеПараметра(ЭтаФорма, "ВидСубконто");
	СубконтоМежд     = ДанныеПараметра(ЭтаФорма, "ЗначениеСубконтоМежд");
	СубконтоРегл     = ДанныеПараметра(ЭтаФорма, "ЗначениеСубконтоРегл");
	
	ДопПараметры = Новый Структура("ЭтоМеждународный,Счет,ПланСчетов,ВидСубконто,СубконтоМежд,СубконтоРегл",
									ЭтоМеждународный.Значение,
									Счет.ИД,
									ЭтоМеждународный.ИД,
									ВидСубконто.ИД,
									СубконтоМежд.ИД,
									СубконтоРегл.ИД);
	ЭтаФорма.НастройкиОтчета.Вставить("ДопПараметры", ДопПараметры);
	
	Если ЭтоМеждународный.Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма[ЭтоМеждународный.ИмяЭлемента] = ЭтоМеждународный.Значение;
	ЭтоМеждународный.Элемент.Вид = ВидПоляФормы.ПолеВвода;
	ЭтоМеждународный.Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	ЭтоМеждународный.Элемент.РежимВыбораИзСписка = Истина;
	ЭтоМеждународный.Элемент.КнопкаВыпадающегоСписка = Истина;
	ЭтоМеждународный.Элемент.РедактированиеТекста = Ложь;
	ЭтоМеждународный.Элемент.СписокВыбора.Добавить(Истина, НСтр("ru='Международный учет';uk='Міжнародний облік'"));
	ЭтоМеждународный.Элемент.СписокВыбора.Добавить(Ложь, НСтр("ru='Регламентированный учет';uk='Регламентований облік'"));
	ЭтоМеждународный.Элемент.Ширина = 28;
	ЭтоМеждународный.Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_Команда");
	
	ВидСубконто.Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_Команда");
	
	Элементы = ЭтаФорма.Элементы;
	Элементы.Переместить(ВидСубконто.Заголовок, Элементы.БыстрыеНастройки2_1_1, СубконтоМежд.Заголовок);
	Элементы.Переместить(ВидСубконто.Элемент, Элементы.БыстрыеНастройки2_1_2, СубконтоМежд.Элемент);
	Элементы.Удалить(СубконтоРегл.Заголовок);
	
	
	// Страницы "ГруппаЗначенийСубконто"
	ГруппаЗначенийСубконто = Элементы.Добавить("ГруппаЗначенийСубконто", Тип("ГруппаФормы"), Элементы.БыстрыеНастройки2_1_2);
	ГруппаЗначенийСубконто.Вид = ВидГруппыФормы.Страницы;
	ГруппаЗначенийСубконто.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	//  Страница "СубконтоМеждународное"
	СубконтоМеждународное = Элементы.Добавить("СубконтоМеждународное", Тип("ГруппаФормы"), ГруппаЗначенийСубконто);
	СубконтоМеждународное.Вид = ВидГруппыФормы.Страница;
	СубконтоМеждународное.ОтображатьЗаголовок = Ложь;
	
	// "ЗначениеСубконтоМежд:"
	Элементы.Переместить(СубконтоМежд.Элемент, СубконтоМеждународное);
	
	//  Страница "СубконтоХозрасчетное"
	СубконтоХозрасчетное = Элементы.Добавить("СубконтоХозрасчетное", Тип("ГруппаФормы"), ГруппаЗначенийСубконто);
	СубконтоХозрасчетное.Вид = ВидГруппыФормы.Страница;
	СубконтоХозрасчетное.ОтображатьЗаголовок = Ложь;
	
	// "ЗначениеСубконтоРегл:"
	Элементы.Переместить(СубконтоРегл.Элемент, СубконтоХозрасчетное);
	
	Если ЭтоМеждународный.Значение Тогда
		Счет.Элемент.ОграничениеТипа = Новый ОписаниеТипов("ПланСчетовСсылка.Международный");
		ВидСубконто.Элемент.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные");
		Элементы.ГруппаЗначенийСубконто.ТекущаяСтраница = Элементы.СубконтоМеждународное;
	Иначе
		Счет.Элемент.ОграничениеТипа = Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный");
		ВидСубконто.Элемент.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные");
		Элементы.ГруппаЗначенийСубконто.ТекущаяСтраница = Элементы.СубконтоХозрасчетное;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОтчета = Неопределено;
	ТаблицаЭлементов = ЭлементыОтчетности(ПараметрыОтчета);
	
	// Подготовим и выведем отчет.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных, 
		НастройкиКомпоновкиДанных,
		ДанныеРасшифровки);
		
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ВнешниеНаборыДанных = Новый Структура("ТаблицаЭлементов", ТаблицаЭлементов);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
	ФиксацияСтрокСверху = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ФиксацияСтрокСверху");
	Если ФиксацияСтрокСверху <> Неопределено Тогда
		ДокументРезультат.ФиксацияСверху = ФиксацияСтрокСверху.Значение;
	КонецЕсли;
	
	ФиксацияСтрокСлева = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ФиксацияСтрокСлева");
	Если ФиксацияСтрокСверху <> Неопределено Тогда
		ДокументРезультат.ФиксацияСлева = ФиксацияСтрокСлева.Значение;
	КонецЕсли;
	
	// Поправим надписи компоновки
	Надпись = ДокументРезультат.НайтиТекст("Параметры:",,,,Истина);
	Если Надпись = Неопределено Тогда 
		Надпись = ДокументРезультат.НайтиТекст("Параметри:",,,,Истина);
	КонецЕсли;	
	Если НЕ Надпись = Неопределено Тогда 
		Надпись.Текст = НСтр("ru='Отбор';uk='Відбір'")+":";
		ТекстОтбора = ДокументРезультат.Область(Надпись.Верх,Надпись.Лево+1,Надпись.Верх,Надпись.Лево+1);
		НовыйТекст = "";
		Для Каждого Параметр Из ПараметрыОтчета Цикл
			Если ЗначениеЗаполнено(Параметр.Значение) Тогда
				ПереводСтроки = ?(ПустаяСтрока(НовыйТекст),"",Символы.ПС);
				НовыйТекст = НовыйТекст + ПереводСтроки + Параметр.Представление + Строка(Параметр.Значение);
			КонецЕсли;
		КонецЦикла;
		ТекстОтбора.Текст = НовыйТекст;
		
		// удалим типовые надписи компоновки
		ВсегоСтрок = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Количество()-1;
		Для Сч = 0 По ВсегоСтрок - 1 Цикл
			НомерСтроки = Надпись.Верх + ВсегоСтрок - Сч;
			ЯчейкаЗначения = ДокументРезультат.Область(НомерСтроки, Надпись.Лево+1, НомерСтроки, Надпись.Лево+1);
			СтрокаМакета = ДокументРезультат.Область(НомерСтроки,,НомерСтроки);
			ДокументРезультат.УдалитьОбласть(СтрокаМакета, ТипСмещенияТабличногоДокумента.ПоВертикали);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭлементыОтчетности(ПараметрыОтчета)
	
	Перем Счет,ВидСубконто,ЗначениеСубконто;
	
	ПараметрыОтчета = Новый СписокЗначений;
	Параметр = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПланСчетов");
	ЭтоМеждународный = Истина;
	Если Параметр <> Неопределено Тогда
		ЭтоМеждународный = Параметр.Значение;
	КонецЕсли;
	
	Параметр = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СчетПланаСчетов");
	Если Параметр <> Неопределено Тогда
		Счет = Параметр.Значение;
	КонецЕсли;
	ПараметрыОтчета.Добавить(Счет, НСтр("ru='Счет';uk='Рахунок'")+": ");
	
	Параметр = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВидСубконто");
	Если Параметр <> Неопределено Тогда
		ВидСубконто = Параметр.Значение;
	КонецЕсли;
	ПараметрыОтчета.Добавить(ВидСубконто, НСтр("ru='Вид субконто';uk='Вид субконто'")+": ");
	
	Параметр = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, ?(ЭтоМеждународный,"ЗначениеСубконтоМежд","ЗначениеСубконтоРегл"));
	Если Параметр <> Неопределено Тогда
		ЗначениеСубконто = Параметр.Значение;
	КонецЕсли;
	ПараметрыОтчета.Добавить(ЗначениеСубконто, НСтр("ru='Субконто';uk='Субконто'")+": ");
	
	// Проверим, указано ли что-нибудь для поиска
	Если НЕ ЗначениеЗаполнено(Счет)
		И НЕ ЗначениеЗаполнено(ВидСубконто)
		И НЕ ЗначениеЗаполнено(ЗначениеСубконто) Тогда
		ВызватьИсключение НСтр("ru='Отчет не сформирован. Необходимо выбрать счет, вид субконто или значение субконто.';uk='Звіт не сформований. Необхідно вибрати рахунок, вид субконто, або значення субконто.'") ;
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Структура[1].Использование = ЗначениеЗаполнено(Счет) И ТипЗнч(Счет) = Тип("ПланСчетовСсылка.Международный");
	
	Схема = ПолучитьМакет("ПоказателиОтчетов");
	Компоновщик = ФинансоваяОтчетностьСервер.КомпоновщикСхемы(Схема);
	Если ЗначениеЗаполнено(Счет) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик,"СчетПланаСчетов",Счет);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидСубконто) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик,"ВидСубконто",ВидСубконто);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗначениеСубконто) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик,"ЗначениеСубконто",ЗначениеСубконто);
	КонецЕсли;
	ЭлементыОтчетов = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(Схема, Компоновщик);
	
	Возврат ЭлементыОтчетов;
	
КонецФункции

Функция ДанныеПараметра(Форма, ИмяПараметра)
	
	Параметр = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, ИмяПараметра);
	Если Параметр <> Неопределено Тогда
		Идентификатор = Параметр.ИдентификаторПользовательскойНастройки;
		ИмяЭлемента = "ЗначениеПараметраНастроек_Значение_"+СтрЗаменить(Идентификатор,"-","");
		ИмяЗаголовка = "ЗначениеПараметраНастроек_Заголовок_"+СтрЗаменить(Идентификатор,"-","");
		Элемент = Форма.Элементы.Найти(ИмяЭлемента);
		Заголовок = Форма.Элементы.Найти(ИмяЗаголовка);
		Возврат Новый Структура("ИД, ИмяЭлемента, Элемент, Заголовок, Значение", Идентификатор, ИмяЭлемента, Элемент, Заголовок, Параметр.Значение);
	КонецЕсли;
	
КонецФункции

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
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		НастройкиОтчета = НастройкиОтчета(Параметры.ПараметрКоманды);
		
		Параметры.ПользовательскиеНастройки = НастройкиОтчета.ПользовательскиеНастройки;
		Параметры.ФиксированныеНастройки = НастройкиОтчета.ФиксированныеНастройки;
		ЭтаФорма.ФормаПараметры.ФиксированныеНастройки = НастройкиОтчета.ФиксированныеНастройки;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НастройкиОтчета(Счет)
	
	// Настройки контекстного отчета
	КомпоновщикНастроекДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	ИмяСхемы = Метаданные.Отчеты.ИспользованиеСчетовИСубконтоМеждународныйУчет.ОсновнаяСхемаКомпоновкиДанных.Имя;
	СхемаОтчета = Отчеты.ИспользованиеСчетовИСубконтоМеждународныйУчет.ПолучитьМакет(ИмяСхемы);
	НастройкиВарианта = СхемаОтчета.ВариантыНастроек.ИспользованиеСчетаКонтекст.Настройки;
	КомпоновщикНастроекДанных.ЗагрузитьНастройки(НастройкиВарианта);
	ПользовательскиеНастройки = КомпоновщикНастроекДанных.ПользовательскиеНастройки;
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ЭтоМеждународный", Истина);
	
	// Установим параметры контекстного отчета
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "СчетПланаСчетов", Счет);
	
	Возврат КомпоновщикНастроекДанных;
	
КонецФункции

#КонецОбласти

#КонецЕсли
