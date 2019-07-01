////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает таблицу с информационными ссылками для форм
//
// Параметры:
//	ХешПутьКФорме - Строка - хеш полного пути к форме.
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица информационных ссылок для формы с колонками:
//		Наименование - Строка - наименование информационной ссылки
//		Адрес - Строка - внешний адрес информационной ссылки
//		Вес - Число - вес информационной ссылки
//		ДатаНачалаАктуальности - Дата - дата начала актуальности информационной ссылки
//		ДатаОкончанияАктуальности - Дата - дата окончания актуальности информационной ссылки
//		Подсказка - Строка - подсказка для информационной ссылки
//
Функция ПолучитьТаблицуИнформационныхСсылокДляФормы(ХешПутьКФорме) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Хеш", ХешПутьКФорме);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолныеПутиКФормам.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ПутиКФормам
	|ИЗ
	|	Справочник.ПолныеПутиКФормам КАК ПолныеПутиКФормам
	|ГДЕ
	|	ПолныеПутиКФормам.Хеш = &Хеш
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИнформационныеСсылкиДляФорм.Наименование КАК Наименование,
	|	ИнформационныеСсылкиДляФорм.Адрес КАК Адрес,
	|	ИнформационныеСсылкиДляФорм.Вес КАК Вес,
	|	ИнформационныеСсылкиДляФорм.ДатаНачалаАктуальности КАК ДатаНачалаАктуальности,
	|	ИнформационныеСсылкиДляФорм.ДатаОкончанияАктуальности КАК ДатаОкончанияАктуальности,
	|	ИнформационныеСсылкиДляФорм.Подсказка КАК Подсказка
	|ИЗ
	|	ПутиКФормам КАК ПутиКФормам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	|		ПО ПутиКФормам.Ссылка = ИнформационныеСсылкиДляФорм.ПолныйПутьКФорме
	|ГДЕ
	|	ИнформационныеСсылкиДляФорм.ДатаНачалаАктуальности <= &ТекущаяДата
	|	И ИнформационныеСсылкиДляФорм.ДатаОкончанияАктуальности >= &ТекущаяДата
	|
	|УПОРЯДОЧИТЬ ПО
	|	Вес УБЫВ";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
