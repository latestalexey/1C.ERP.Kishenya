
#Область ПрограммныйИнтерфейс

// Процедура выполняет обработку неизвестных штрихкодов. В зависимости от наличия прав пользователя, выдает сообщение
// о неизвестных штрихкодах или открывает форму регистрации новых штрихкодов номенклатуры.
//
// Параметры:
//  СтруктураПараметровДействия - Структура
//  КэшированныеЗначения        - Структура
//  ФормаВладелец               - Форма
//
Процедура ОбработатьНеизвестныеШтрихкоды(СтруктураПараметровДействия, КэшированныеЗначения, ФормаВладелец) Экспорт
	
	Если СтруктураПараметровДействия.НеизвестныеШтрихкоды.Количество() > 0 Тогда
		
		Если Не (КэшированныеЗначения.ПравоРегистрацииШтрихкодовНоменклатурыДоступно
			И СтруктураПараметровДействия.ДействияСНеизвестнымиШтрихкодами <> "НетДействий"
			И СтруктураПараметровДействия.ИзменятьКоличество)Тогда
			
			Если СтруктураПараметровДействия.УчитыватьУпаковочныеЛисты Тогда
				ШаблонСообщения = НСтр("ru='Номенклатура или упаковочный лист со штрихкодом %1% не найдены';uk='Номенклатура або пакувальний лист зі штрихкодом %1% не знайдені'");
			Иначе
				ШаблонСообщения = НСтр("ru='Номенклатура со штрихкодом %1% не найдена';uk='Номенклатура зі штрихкодом %1% не знайдена'");
			КонецЕсли;
			Для Каждого ТекНеизвестныйШтрихкод Из СтруктураПараметровДействия.НеизвестныеШтрихкоды Цикл
				
				СтрокаСообщения = СтрЗаменить(ШаблонСообщения, "%1%", СокрЛП(ТекНеизвестныйШтрихкод.Штрихкод));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
				
			КонецЦикла;
		Иначе
			ОткрытьФорму(
				"РегистрСведений.ШтрихкодыНоменклатуры.Форма.РегистрацияШтрихкодовНоменклатуры",
				СтруктураПараметровДействия,
				ФормаВладелец,
				Новый УникальныйИдентификатор);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура показывает ввод штрихкода и оповещает в случае успешного ввода
//
// Параметры:
//  ОповещениеУспешногоВвода - ОписаниеОповещения - описание оповещения успешного ввода штрихкода
//  Заголовок                - Строка             - переопределяемый загловок
Процедура ПоказатьВводШтрихкода(ОповещениеУспешногоВвода, Количество = Неопределено, Заголовок = "") Экспорт 
	
	Если НЕ ЗначениеЗаполнено(Заголовок) Тогда
		Заголовок = НСтр("ru='Введите штрихкод';uk='Введіть штрихкод'");
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура(
		"ОповещениеУспешногоВвода, Количество",
		ОповещениеУспешногоВвода,
		Количество);
	Оповещение = Новый ОписаниеОповещения(
		"ПоказатьВводШтрихкодаЗавершение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	ПоказатьВводЗначения(Оповещение, "", Заголовок);
	
КонецПроцедуры

//Возвращает структуру параметров обработки штрихкодов
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Структура - Параметры обработки штрихкодов
//
Функция ПараметрыОбработкиШтрихкодов() Экспорт
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Штрихкоды",                                      Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСДобавленнымиСтроками",         Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСИзмененнымиСтроками",          Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСоСтрокамиИзУпаковочныхЛистов", Неопределено);
	ПараметрыОбработки.Вставить("ПараметрыУказанияСерий",                 Неопределено);
	ПараметрыОбработки.Вставить("ДействияСНеизвестнымиШтрихкодами",       "ЗарегистрироватьПеренестиВДокумент");
	ПараметрыОбработки.Вставить("ИмяКолонкиКоличество",                   "КоличествоУпаковок");
	ПараметрыОбработки.Вставить("НеИспользоватьУпаковки",                 Ложь);
	ПараметрыОбработки.Вставить("ИмяТЧ",                                  "Товары");
	ПараметрыОбработки.Вставить("ИзменятьКоличество",                     Истина);
	ПараметрыОбработки.Вставить("БлокироватьДанныеФормы",                 Истина);
	ПараметрыОбработки.Вставить("ТолькоТовары",                           Ложь);
	ПараметрыОбработки.Вставить("ТолькоУслуги",                           Ложь);
	ПараметрыОбработки.Вставить("ТолькоТара",                             Ложь);
	ПараметрыОбработки.Вставить("ТолькоНеПодакцизныйТовар",               Ложь);
	ПараметрыОбработки.Вставить("НеизвестныеШтрихкоды",                   Новый Массив);
	ПараметрыОбработки.Вставить("ОтложенныеТовары",                       Новый Массив);
	ПараметрыОбработки.Вставить("ПараметрыПроверкиАссортимента",          Неопределено);
	ПараметрыОбработки.Вставить("РассчитыватьНаборы",                     Ложь);
	ПараметрыОбработки.Вставить("УчитыватьУпаковочныеЛисты",              Ложь);
	ПараметрыОбработки.Вставить("ОтработатьИзменениеУпаковочныхЛистов",   Ложь);
	ПараметрыОбработки.Вставить("ШтрихкодыВТЧ",                           Ложь);
	ПараметрыОбработки.Вставить("УвеличиватьКоличествоВСтрокахССериями",  Истина);
	ПараметрыОбработки.Вставить("ТекущийУпаковочныйЛист",                 Неопределено);
	ПараметрыОбработки.Вставить("ЗаполнятьНазначения",                    Ложь);
	
	//Возвращаемые параметры
	ПараметрыОбработки.Вставить("МассивСтрокССериями",          Новый Массив);
	ПараметрыОбработки.Вставить("ТекущаяСтрока",       Неопределено);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

//Определяет необходимость открытия формы указания серий после обработки штрихкодов. Форму нужно
//открывать, если был отсканирован один штрихкод товара, по которому ведется учет серий
//
// Параметры:
//  ПараметрыОбработкиШтрихкодов - Структура - см. ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов()
//
// Возвращаемое значение:
//  Булево
//
Функция НужноОткрытьФормуУказанияСерийПослеОбработкиШтрихкодов(ПараметрыОбработкиШтрихкодов) Экспорт
	
	ОдинШтрихкод = Ложь;
	
	Если ТипЗнч(ПараметрыОбработкиШтрихкодов.Штрихкоды) = Тип("Массив") Тогда
		ОдинШтрихкод = ПараметрыОбработкиШтрихкодов.Штрихкоды.Количество() = 1;
	Иначе
		ОдинШтрихкод = Истина;
	КонецЕсли;
	
	Если ОдинШтрихкод 
		И ПараметрыОбработкиШтрихкодов.МассивСтрокССериями.Количество() = 1
		И НоменклатураКлиентСервер.НеобходимоРегистрироватьСерии(
			ПараметрыОбработкиШтрихкодов.ПараметрыУказанияСерий) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Определяет необходимость открытия формы указания акцизных марок после обработки штрихкодов. Форму нужно
// открывать, если был отсканирован один штрихкод маркируемой алкогольной продукции
//
// Параметры:
//  ПараметрыОбработкиШтрихкодов - Структура - см. ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов()
//
// Возвращаемое значение:
//  Булево
//
Функция НужноОткрытьФормуУказанияАкцизныхМарокПослеОбработкиШтрихкодов(ПараметрыОбработкиШтрихкодов) Экспорт
	
	ОдинШтрихкод = Ложь;
	
	Если ТипЗнч(ПараметрыОбработкиШтрихкодов.Штрихкоды) = Тип("Массив") Тогда
		ОдинШтрихкод = ПараметрыОбработкиШтрихкодов.Штрихкоды.Количество() = 1;
	Иначе
		ОдинШтрихкод = Истина;
	КонецЕсли;
	
	Если ОдинШтрихкод
		И ПараметрыОбработкиШтрихкодов.МассивСтрокСАкцизнымиМарками.Количество() = 1 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

//Возвращает структуру, которая затем обрабатывается процедурами заполнения ТЧ
//Параметры:
//  Штрихкод - штрихкод, который необходимо обработать
//  Количество - количество товаров с указанным штрихкодом
//
Функция СтруктураДанныхШтрихкода(Штрихкод, Количество) Экспорт

	Возврат Новый Структура("Штрихкод, Количество", Штрихкод, Количество);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьВводШтрихкодаЗавершение(Штрихкод, ДополнительныеПараметры) Экспорт
	
	ОповещениеУспешногоВвода = ДополнительныеПараметры.ОповещениеУспешногоВвода;
	Количество = ДополнительныеПараметры.Количество;
	
	Если (Штрихкод <> Неопределено) Тогда
		Если Не ПустаяСтрока(Штрихкод) Тогда
			Если Количество = Неопределено Тогда
				Количество = 1;
			КонецЕсли;
			ВыполнитьОбработкуОповещения(
				ОповещениеУспешногоВвода,
				СтруктураДанныхШтрихкода(Штрихкод, Количество));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
