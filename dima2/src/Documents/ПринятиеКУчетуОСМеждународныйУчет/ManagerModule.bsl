#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПринятиеКУчетуОСМеждународныйУчет) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ПринятиеКУчетуОСМеждународныйУчет.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ПринятиеКУчетуОСМеждународныйУчет);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьДокументыВнеоборотныхАктивовМеждународныйУчет";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры);
	Международный(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.ПорядокУчета,
	|	ДанныеДокумента.ВидАктива,
	|	ДанныеДокумента.МетодНачисленияАмортизации,
	|	ДанныеДокумента.СрокИспользования,
	|	ДанныеДокумента.СчетКапитальныхВложений,
	|	ДанныеДокумента.СчетУчета,
	|	ДанныеДокумента.СчетАмортизации,
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов,
	|	ДанныеДокумента.ПоказательНаработки,
	|	ДанныеДокумента.ОбъемНаработки,
	|	ДанныеДокумента.КоэффициентУскорения,
	|	ДанныеДокумента.ЛиквидационнаяСтоимость,
	|	ДанныеДокумента.ЛиквидационнаяСтоимостьПредставления,
	|	ДанныеДокумента.ПервоначальнаяСтоимость,
	|	ДанныеДокумента.ПервоначальнаяСтоимостьПредставления
	|ИЗ
	|	Документ.ПринятиеКУчетуОСМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	Запрос.УстановитьПараметр("Граница", Новый Граница(Реквизиты.Дата, ВидГраницы.Исключая));
	
КонецПроцедуры

Процедура ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаОС";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица ТаблицаОС
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка,
	|	ТаблицаОС.НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство,
	|	ТаблицаОС.ИнвентарныйНомер
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Документ.ПринятиеКУчетуОСМеждународныйУчет.ОсновныеСредства КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ОсновныеСредстваМеждународныйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОсновныеСредстваМеждународныйУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ОсновныеСредстваМеждународныйУчет
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	ВЫБОР
	|		КОГДА &ПорядокУчета=ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету)
	|	КОНЕЦ КАК Состояние,
	|	ТаблицаОС.ИнвентарныйНомер,
	|	&СчетУчета КАК СчетУчета,
	|	&ВидАктива КАК ВидАктива,
	|	&ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	&ЛиквидационнаяСтоимостьПредставления КАК ЛиквидационнаяСтоимостьПредставления,
	|	&ПорядокУчета КАК ПорядокУчета,
	|	&МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	&СчетАмортизации КАК СчетАмортизации,
	|	&СрокИспользования КАК СрокИспользования,
	|	&ПоказательНаработки КАК ПоказательНаработки,
	|	&ОбъемНаработки КАК ОбъемНаработки,
	|	&КоэффициентУскорения КАК КоэффициентУскорения,
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура Международный(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "Международный";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица Международный
	|"+
	"ВЫБРАТЬ
	|	&Дата КАК Период,
	|	&Ссылка КАК Регистратор,
	|	
	|	&Организация КАК Организация,
	|	&ПервоначальнаяСтоимость КАК Сумма,
	|	&ПервоначальнаяСтоимостьПредставления КАК СуммаПредставления,
	|	
	|	&СчетУчета КАК СчетДт,
	|	&Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	ТаблицаОС.ОсновноеСредство КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	&СчетКапитальныхВложений КАК СчетКт,
	|	&Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	ТаблицаОС.ОсновноеСредство КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства) КАК ВидСубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|ГДЕ
	|	НЕ (&ПервоначальнаяСтоимость=0 И &ПервоначальнаяСтоимостьПредставления=0)
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеМеждународныйУчет

Процедура ЗаполнитьТаблицуДокументаКОтражениюВМеждународномУчете(ТаблицаДокумента, Документ) Экспорт

	НоваяСтрока = ТаблицаДокумента.Добавить();
	НоваяСтрока.Регистратор = Документ.Ссылка;
	НоваяСтрока.Организация = Документ.Организация;

КонецПроцедуры

Функция ТекстОтраженияВМеждународномУчете() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ДанныеДокумента.Ссылка.Дата КАК Дата,
	|	ДанныеДокумента.Ссылка.Организация КАК Организация,
	|	ДанныеДокумента.Ссылка.Подразделение КАК Подразделение,
	|	ДанныеДокумента.ОсновноеСредство КАК Объект,
	|	ДанныеДокумента.Ссылка.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	ДанныеДокумента.Ссылка.ПервоначальнаяСтоимостьПредставления КАК ПервоначальнаяСтоимостьПредставления,
	|	ДанныеДокумента.Ссылка.СчетКапитальныхВложений КАК СчетКапитальныхВложений,
	|	ДанныеДокумента.Ссылка.СчетУчета КАК СчетУчета,
	|	ДанныеДокумента.Ссылка.СчетРасходов КАК СчетРасходов,
	|	ДанныеДокумента.Ссылка.СчетРасходовСубконто1 КАК СчетРасходовСубконто1,
	|	ДанныеДокумента.Ссылка.СчетРасходовСубконто2 КАК СчетРасходовСубконто2,
	|	ДанныеДокумента.Ссылка.СчетРасходовСубконто3 КАК СчетРасходовСубконто3
	|ПОМЕСТИТЬ Операции
	|ИЗ
	|	Документ.ПринятиеКУчетуОСМеждународныйУчет.ОсновныеСредства КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДокументыКОтражению КАК ДокументыКОтражению
	|		ПО ДанныеДокумента.Ссылка = ДокументыКОтражению.Регистратор
	|			И ДанныеДокумента.Ссылка.Организация = ДокументыКОтражению.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	ДанныеДокумента.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Операции.Объект КАК Объект,
	|	СУММА(КапитальныеВложения.Сумма) КАК Сумма,
	|	СУММА(КапитальныеВложения.СуммаПредставления) КАК СуммаПредставления
	|ПОМЕСТИТЬ КапитальныеВложения
	|ИЗ
	|	Операции КАК Операции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.ДвиженияССубконто(
	|				,
	|				,
	|				НЕ Регистратор В
	|							(ВЫБРАТЬ
	|								Операции.Регистратор
	|							ИЗ
	|								Операции)
	|					И (Организация, Подразделение, СчетДт, Субконто1) В
	|						(ВЫБРАТЬ
	|							Операции.Организация,
	|							Операции.Подразделение,
	|							Операции.СчетКапитальныхВложений,
	|							Операции.Объект
	|						ИЗ
	|							Операции КАК Операции),
	|				,
	|				) КАК КапитальныеВложения
	|		ПО Операции.Объект = КапитальныеВложения.СубконтоДт1
	|			И (КОНЕЦПЕРИОДА(Операции.Регистратор.Дата, МЕСЯЦ) > КапитальныеВложения.Период)
	|			И Операции.СчетКапитальныхВложений = КапитальныеВложения.СчетДт
	|			И (КапитальныеВложения.Активность)
	|
	|СГРУППИРОВАТЬ ПО
	|	Операции.Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК ТипПроводки, // Передача стоимости со счета капитальных затрат на счет учета
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	0 КАК Сумма,
	|	0 КАК СуммаПредставления,
	|	
	|	Операции.СчетУчета КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.Объект КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетКапитальныхВложений КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|	
	|ПОМЕСТИТЬ Проводки
	|ИЗ
	|	Операции КАК Операции
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1 КАК ТипПроводки, // Передача стоимости со счета капитальных затрат на счет учета
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	Операции.ПервоначальнаяСтоимость КАК Сумма,
	|	Операции.ПервоначальнаяСтоимостьПредставления КАК СуммаПредставления,
	|	
	|	Операции.СчетУчета КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.Объект КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетКапитальныхВложений КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|	
	|ИЗ
	|	Операции КАК Операции
	|ГДЕ
	|	Операции.Регистратор.ПервоначальнаяСтоимость <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1 КАК ТипПроводки, // Передача стоимости со счета капитальных затрат на счет учета
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	ЕСТЬNULL(КапитальныеВложения.Сумма, 0) - Операции.ПервоначальнаяСтоимость КАК Сумма,
	|	ЕСТЬNULL(КапитальныеВложения.СуммаПредставления, 0) - Операции.ПервоначальнаяСтоимостьПредставления КАК СуммаПредставления,
	|	
	|	Операции.СчетУчета КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.Объект КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетКапитальныхВложений КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|	
	|ИЗ
	|	Операции КАК Операции
	|		ЛЕВОЕ СОЕДИНЕНИЕ КапитальныеВложения КАК КапитальныеВложения
	|		ПО Операции.Объект = КапитальныеВложения.Объект
	|ГДЕ
	|	ЕСТЬNULL(КапитальныеВложения.Сумма, 0) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК ТипПроводки, // Списание стоимости со счета учета на счет расходов
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	ЕСТЬNULL(КапитальныеВложения.Сумма, 0) КАК Сумма,
	|	ЕСТЬNULL(КапитальныеВложения.СуммаПредставления, 0) КАК СуммаПредставления,
	|	
	|	Операции.СчетРасходов КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.СчетРасходовСубконто1 КАК СубконтоДт1,
	|	Операции.СчетРасходовСубконто2 КАК СубконтоДт2,
	|	Операции.СчетРасходовСубконто3 КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетУчета КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|ИЗ
	|	Операции КАК Операции
	|	ЛЕВОЕ СОЕДИНЕНИЕ КапитальныеВложения КАК КапитальныеВложения
	|		ПО Операции.Объект = КапитальныеВложения.Объект
	|ГДЕ
	|	Операции.Регистратор.ПорядокУчета = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ВалютаФункциональная КАК ВалютаХраненияСуммыФункциональной,
	|	&ВалютаПредставления КАК ВалютаХраненияСуммыПредставления,
	|	Проводки.ТипПроводки КАК ТипПроводки,
	|	Проводки.Период,
	|	Проводки.Регистратор,
	|	Проводки.Организация,
	|	СУММА(Проводки.Сумма) КАК Сумма,
	|	СУММА(Проводки.СуммаПредставления) КАК СуммаПредставления,
	|	Проводки.СчетДт,
	|	Проводки.ПодразделениеДт,
	|	Проводки.ВалютаДт,
	|	Проводки.СубконтоДт1,
	|	Проводки.СубконтоДт2,
	|	Проводки.СубконтоДт3,
	|	СУММА(Проводки.ВалютнаяСуммаДт) КАК ВалютнаяСуммаДт,
	|	Проводки.СчетКт,
	|	Проводки.ПодразделениеКт,
	|	Проводки.ВалютаКт,
	|	Проводки.СубконтоКт1,
	|	Проводки.СубконтоКт2,
	|	Проводки.СубконтоКт3,
	|	СУММА(Проводки.ВалютнаяСуммаКт) КАК ВалютнаяСуммаКт
	|ИЗ
	|	Проводки КАК Проводки
	|
	|СГРУППИРОВАТЬ ПО
	|	Проводки.ТипПроводки,
	|	Проводки.Период,
	|	Проводки.Регистратор,
	|	Проводки.Организация,
	|	Проводки.СчетДт,
	|	Проводки.ПодразделениеДт,
	|	Проводки.ВалютаДт,
	|	Проводки.СубконтоДт1,
	|	Проводки.СубконтоДт2,
	|	Проводки.СубконтоДт3,
	|	Проводки.СчетКт,
	|	Проводки.ПодразделениеКт,
	|	Проводки.ВалютаКт,
	|	Проводки.СубконтоКт1,
	|	Проводки.СубконтоКт2,
	|	Проводки.СубконтоКт3
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипПроводки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Операции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Проводки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ КапитальныеВложения";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ПроверитьЗаполнениеПроводкиМеждународногоУчета(Проводка, Выборка) Экспорт
	
	Если Проводка.Сумма = 0 Тогда
		
		Если Выборка.ТипПроводки = 1 Тогда // Передача первоначальной стоимости на счет учета
			
			Проводка.Статус = МеждународныйУчетСерверПовтИсп.Статус(
				Проводка.Статус,
				Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете);
			
			ТекстОшибки = НСтр("ru='Первоначальная стоимость ОС ""%Объект%"" на счете капитальных вложений отсутствует';uk='Первісна вартість ОЗ ""%Объект%"" на рахунку капітальних вкладень відсутня'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%", Проводка.СубконтоДт1);
			Проводка.МассивОшибок.Добавить(ТекстОшибки);
			
		КонецЕсли;
		
		Если Выборка.ТипПроводки = 2 Тогда // Передача первоначальной стоимости на счет учета
			
			Проводка.Статус = МеждународныйУчетСерверПовтИсп.Статус(
				Проводка.Статус,
				Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете);
			
			ТекстОшибки = НСтр("ru='Стоимость ОС ""%Объект%"" на счете учета отсутствует';uk='Вартість ОС ""%Объект%"" на рахунку обліку відсутня'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%", Проводка.СубконтоКт1);
			Проводка.МассивОшибок.Добавить(ТекстОшибки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли