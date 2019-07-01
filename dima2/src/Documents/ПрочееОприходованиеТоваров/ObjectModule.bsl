#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
 	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		
		Операция = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ХозяйственнаяОперация");
		
		Если Операция = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию Тогда
			ЗаполнитьДокументНаОснованииСписанияНаРасходы(ДанныеЗаполнения);
		Иначе
			
			ТекстИсключения = НСтр("ru='Ввод на основании возможен для операции ""Передача в эксплуатацию"" и ""Сторно списания на расходы"".';uk='Введення на підставі можливе для операції ""Передача в експлуатацію"" і ""Сторно списання на витрати"".'");
			
			//++ НЕ УТ
			ТекстИсключения = НСтр("ru='Ввод на основании возможен для операций ""Передача в эксплуатацию"", ""Передача в производство"" и ""Сторно списания на расходы"".';uk='Введення на підставі можливе для операцій ""Передача в експлуатацію"", ""Передача у виробництво"" і ""Сторно списання на витрати"".'");
			//-- НЕ УТ
			
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли;
		
		//++ НЕ УТ
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.СписаниеОС") Тогда
		
		ЗаполнитьДокументНаОснованииСписанияОС(ДанныеЗаполнения);
		//-- НЕ УТ
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Товары") Тогда
		
		ДанныеЗаполнения.Свойство("РеквизитыШапки", РеквизитыШапки);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыШапки);
		Товары.Загрузить(ДанныеЗаполнения.Товары.Выгрузить());
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	//++ НЕ УТ
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратИзПроизводства И НЕ ПометкаУдаления Тогда
		ТекстСообщения = НСтр("ru='Запись документа запрещена, т.к. операция ""Возврат из производства"" больше не используется.
                                |Возврат материалов оформляется в форме ""Производство - Получение и возврат материалов"".'
                                |;uk='Запис документа заборонений, оскільки операція ""Повернення з виробництва"" більше не використовується.
                                |Повернення матеріалів оформляється у формі ""Виробництво - Отримання і повернення матеріалів"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка,,, Отказ);	
	КонецЕсли;
	//-- НЕ УТ
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация, Склад, Подразделение, НЕОПРЕДЕЛЕНО);
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);
		ЗаполнитьВидыЗапасовДокумента(Отказ);
		ЗаполнитьКлючиАналитикиУчетаПартийДокумента();
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ЗапасыСервер.ОчиститьАналитикуУчетаПартийВТабличнойЧасти(Товары);
		ВидыЗапасов.Очистить();
	КонецЕсли;
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПрочееОприходованиеТоваров));
	
	//++ НЕ УТ
	//-- НЕ УТ
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ПрочееОприходованиеТоваров.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);

	ЕстьНазначение = Ложь;
	Если Товары.Количество() > 0 Тогда

		Если Товары.Количество() <> Товары.НайтиСтроки(Новый Структура("Назначение", Справочники.Назначения.ПустаяСсылка())).Количество() Тогда
			ЕстьНазначение = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ДанныеВнутреннихДокументов.ЗаписатьДанныеДокумента(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ПрочееОприходованиеТоваров.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	// Проверка количества в т.ч. товары.
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	// Проверка характеристик в т.ч. товары.
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПрочееОприходованиеТоваров),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	Если МассивРеквизитовОперации.Найти("Товары.СтатьяРасходов")<>Неопределено Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, Новый Структура("Товары"), МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	Если МассивРеквизитовОперации.Найти("Товары.СтатьяДоходов")<>Неопределено Тогда
		ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, Новый Структура("Товары"), МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ПартияТМЦВЭксплуатации");
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы Тогда
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПрочееОприходованиеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	РегистрыНакопления.ТоварыКОформлениюПоступления.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ПартионныйУчетСервер.ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ОтразитьДвижения(
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаТМЦВЭксплуатации,
		Движения.ТМЦВЭксплуатации,
		Отказ);
		
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Организация;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Склад;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Подразделение;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

//++ НЕ УТ

Процедура ЗаполнитьДокументНаОснованииСписанияОС(Знач ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочееПоступлениеТоваров) КАК ХозяйственнаяОперация,
	|	Документ.Подразделение КАК Подразделение,
	|	Документ.Организация КАК Организация,
	|	Документ.Ссылка КАК ДокументОснование
	|ИЗ
	|	Документ.СписаниеОС КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Количество КАК Количество,
	|	Товары.Количество КАК КоличествоУпаковок,
	|	НЕОПРЕДЕЛЕНО КАК Упаковка,
	|	НЕОПРЕДЕЛЕНО КАК Назначение
	|ИЗ
	|	Документ.СписаниеОС.ПриходуемыеМЦ КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И Товары.Количество > 0";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры

//-- НЕ УТ
Процедура ЗаполнитьДокументНаОснованииСписанияНаРасходы(Знач ДокументОснование)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы) КАК ХозяйственнаяОперация,
	|	ВнутреннееПотреблениеТоваров.Ссылка КАК ДокументОснование,
	|	ВнутреннееПотреблениеТоваров.Склад КАК Склад,
	|	ВнутреннееПотреблениеТоваров.Подразделение КАК Подразделение,
	|	ВнутреннееПотреблениеТоваров.Организация КАК Организация,
	|	ВнутреннееПотреблениеТоваров.НалоговоеНазначение КАК НалоговоеНазначение,
	|	НЕ ВнутреннееПотреблениеТоваров.Проведен КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|ГДЕ
	|	ВнутреннееПотреблениеТоваров.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	&Ссылка КАК СписаниеНаРасходы,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	Товары.СтатьяРасходов КАК СтатьяРасходов,
	|	Товары.АналитикаРасходов КАК АналитикаРасходов
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование, , ВыборкаШапка.ЕстьОшибкиПроведен);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры


Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	ВидЦены       = Справочники.Склады.УчетныйВидЦены(Склад);
	НалоговоеНазначение = ЗначениеНастроекПовтИсп.НалоговоеНазначениеОрганизации(Организация, Дата, НалоговоеНазначение);

КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасовДокумента(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы Тогда
//++ НЕ УТКА
	ЗаполнитьВидыЗапасовДавальцевВТабличнойЧастиТовары(МенеджерВременныхТаблиц);
//-- НЕ УТКА
	ЗапасыСервер.ЗаполнитьВидыЗапасовВТабличнойЧастиТовары(МенеджерВременныхТаблиц, Товары);
	
	Иначе
	
		СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
		ЗапасыСервер.УстановитьБлокировкуОстатковТоваровОрганизаций(МенеджерВременныхТаблиц);
		ЗапасыСервер.ТаблицаОстатковСписанныхНаРасходыТоваров(
			Ссылка,
			Организация,
			Склад,
			МенеджерВременныхТаблиц
			);
		ТаблицаОшибок = ЗапасыСервер.ТаблицаОшибокЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовДокумента(
			МенеджерВременныхТаблиц,
			ДополнительныеСвойства,
			ВидыЗапасов,
			ТаблицаОшибок);
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, ВидЗапасовОтгрузки, СкладОтгрузки, ДокументРеализации, СтатьяРасходов, АналитикаРасходов",
								   "Количество");
		
		ЗаполнитьСтатьюРасходовВидовЗапасов();
		СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц, Отказ);
	
	КонецЕсли;

КонецПроцедуры

//++ НЕ УТКА

Процедура ЗаполнитьВидыЗапасовДавальцевВТабличнойЧастиТовары(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВидыЗапасовДавальца.НомерСтроки - 1	КАК Индекс,
	|	ВидыЗапасовДавальца.ВидЗапасов		КАК ВидЗапасов
	|ИЗ
	|	ВидыЗапасовДавальца КАК ВидыЗапасовДавальца");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		// Для Давальцев подбираем уже существующие виды запасов
		Товары[Выборка.Индекс].ВидЗапасов = Выборка.ВидЗапасов;
	КонецЦикла;
	
КонецПроцедуры

//-- НЕ УТКА

// Процедура формирует временную таблицу доступных видов запасов
//
// Параметры:
//	МенеджерВременныхТаблиц - Менеджер временных таблиц
//
Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасовПродавца
	|
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Процедура заполняет статью и аналитику расходов видов запасов документа.
//
Процедура ЗаполнитьСтатьюРасходовВидовЗапасов()
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	Для Каждого СтрокаТоваров Из Товары Цикл
		
		КоличествоТоваров = СтрокаТоваров.Количество;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.СтатьяРасходов = СтрокаТоваров.СтатьяРасходов;
			НоваяСтрока.АналитикаРасходов = СтрокаТоваров.АналитикаРасходов;
			НоваяСтрока.Количество = Количество;
			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			
			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц, Отказ)
	
	Если ТаблицаОшибок.Количество() > 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Сторнирование превышает остаток списанного товара организации %1 на складе %2';uk='Сторнування перевищує залишок списаного товару організації %1 на складі %2'"),
			Организация,
			Склад);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект);
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Номенклатура: %1, недостаточно %2 %3';uk='Номенклатура: %1, недостатньо %2 %3'"),
				НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика),
				СтрокаТаблицы.Количество,
				СтрокаТаблицы.ЕдиницаИзмерения);
			
			Если СтрокаТаблицы.НеУказанНомерГТД Тогда
				ТекстСообщения = ТекстСообщения + НСтр("ru='с указанными номерами ГТД';uk='із зазначеними номерами ВМД'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				Ссылка);
			
		КонецЦикла;
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Функция формирует временные таблицы данных документа.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	&НалоговоеНазначение КАК НалоговоеНазначение,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ТаблицаТоваровДавальца
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ ТаблицаТоваров.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	//++ НЕ УТКА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|	
	|ПОМЕСТИТЬ ВидыЗапасовДавальца
	|ИЗ
	|	ТаблицаТоваровДавальца КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.Назначения КАК Назначения
	|	ПО
	|		ТаблицаТоваров.Назначение = Назначения.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаказДавальца КАК ЗаказДавальца
	|	ПО
	|		Назначения.Заказ = ЗаказДавальца.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ВидыЗапасов КАК ВидыЗапасов
	|	ПО
	|		ТаблицаТоваров.Назначение = ВидыЗапасов.Назначение
	|		И ЗаказДавальца.Организация = ВидыЗапасов.Организация
	|		И ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца) = ВидыЗапасов.ТипЗапасов
	//-- НЕ УТКА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ТаблицаТоваров.НалоговоеНазначение КАК НалоговоеНазначение,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
 	|	НАЗНАЧЕНИЕ	 КАК Поставщик,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаПродукции
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваровДавальца КАК ТаблицаТоваров
	//++ НЕ УТКА
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВидыЗапасовДавальца КАК ВидыЗапасовДавальца
	|	ПО
	|		ТаблицаТоваров.НомерСтроки = ВидыЗапасовДавальца.НомерСтроки
	|
	|ГДЕ
	|	ВидыЗапасовДавальца.ВидЗапасов ЕСТЬ NULL
	//-- НЕ УТКА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти
	|	
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	&Склад КАК Склад,
	|	
	|	ТаблицаТоваров.СписаниеНаРасходы КАК ДокументРеализации,
	|	
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения
	|	
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК ЦелевоеНалоговоеНазначение,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.ДокументРеализации,
	|	ТаблицаТоваров.Сделка КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ВЫБОР КОГДА СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|	ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК ПодбиратьВидыЗапасов,
	|	Аналитика.КлючАналитики КАК АналитикаУчетаНоменклатурыОприходования
	|	
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.Номенклатура КАК СпрНоменклатура
	|	ПО
	|		ТаблицаТоваров.Номенклатура = СпрНоменклатура.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаТоваров.Номенклатура = Аналитика.Номенклатура
	|		И ТаблицаТоваров.Характеристика = Аналитика.Характеристика
	|		И ТаблицаТоваров.Серия = Аналитика.Серия
	|		И ТаблицаТоваров.Склад = Аналитика.Склад
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|/////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Аналитика.Номенклатура КАК НоменклатураОприходование,
	|	Аналитика.Характеристика КАК ХарактеристикаОприходование,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	Аналитика.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ЛОЖЬ КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НалоговоеНазначение", НалоговоеНазначение);
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Организация, Дата));
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить());
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов.Выгрузить());
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Процедура ЗаполнитьКлючиАналитикиУчетаПартийДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки 		КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура 	КАК Номенклатура,
	|	ТаблицаТоваров.АналитикаУчетаПартий КАК АналитикаУчетаПартий
	|ПОМЕСТИТЬ ТаблицаТоваровДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки 		КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура 	КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО 					КАК СтавкаНДС,
	|	НЕОПРЕДЕЛЕНО 					КАК Поставщик,
	|	НЕОПРЕДЕЛЕНО 					КАК Контрагент,
	|	&НалоговоеНазначение  			КАК НалоговоеНазначение,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
 	|	ТаблицаТоваров.АналитикаУчетаПартий
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваровДокумента КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.АналитикаУчетаПартий = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)");
	                	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТоваров"		, Товары.Выгрузить(, 
														"НомерСтроки, Номенклатура, АналитикаУчетаПартий"));
	Запрос.УстановитьПараметр("НалоговоеНазначение", НалоговоеНазначение);
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Организация, Дата));
 				
	Запрос.Выполнить();
	
	ПартионныйУчетСервер.ЗаполнитьАналитикуУчетаПартийВТабличнойЧастиТовары(МенеджерВременныхТаблиц, Товары);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
