#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует отчет в табличном документе по указанному объекту основного средства
//
// Параметры:
// 		ТабличныйДокумент - ТабличныйДокумент - Табличный документ, в котором необходимо сформировать отчет
// 		Список - Массив, СписокЗначений - список объектов типа <СправочникСсылка.ОбъектыЭксплуатации> по которым необходимо сформировать отчет
//
Процедура СформироватьОтчет(ТабличныйДокумент, Список, ТолькоРазличия=Ложь) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Очистить();
	
	РеквизитыСравнения = РеквизитыСравнения();
	
	Запрос = Новый Запрос(ТекстЗапросаСравнения(РеквизитыСравнения));
	Запрос.УстановитьПараметр("Список", Список);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Макет = ЭтотОбъект.ПолучитьМакет("Макет");
	
	ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОблОбъект = Макет.ПолучитьОбласть("Объект");
	ОблРаздел = Макет.ПолучитьОбласть("Раздел");
	ОблРеквизит = Макет.ПолучитьОбласть("Реквизит");
	ОблРеквизитРазличные = Макет.ПолучитьОбласть("РеквизитРазличные");
	
	ТабличныйДокумент.Вывести(ОблЗаголовок);
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ТолькоРазличия И Не Выборка.ЕстьРазличия Тогда
			Продолжить;
		КонецЕсли;
		
		ОблОбъект.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОблОбъект);
		
		ТабличныйДокумент.НачатьГруппуСтрок();
		
		Для Каждого Раздел Из РеквизитыСравнения Цикл
			
			ОблРаздел.Параметры.Заполнить(Раздел);
			ТабличныйДокумент.Вывести(ОблРаздел);
			
			ТабличныйДокумент.НачатьГруппуСтрок();
			
			Для Каждого Реквизит Из Раздел.Реквизиты Цикл
				Обл = ?(Выборка[Реквизит.Имя + "Сравнение"], ОблРеквизит, ОблРеквизитРазличные);
				Обл.Параметры.Синоним = Реквизит.Синоним;
				Обл.Параметры.ЗначениеБУ = Формат(Выборка[Реквизит.Имя + "БУ"], Реквизит.Формат);
				Обл.Параметры.ЗначениеМФУ = Формат(Выборка[Реквизит.Имя + "МФУ"], Реквизит.Формат);
				ТабличныйДокумент.Вывести(Обл);
			КонецЦикла;
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
		КонецЦикла;
		
		ТабличныйДокумент.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РеквизитыСравнения()
	
	ОписанияРазделов = Новый Массив;
	
	ОписаниеРаздела = Новый Структура;
	ОписаниеРаздела.Вставить("Синоним", НСтр("ru='Основные сведения';uk='Основні відомості'"));
	ОписаниеРаздела.Вставить("Реквизиты", Новый Массив);
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("Состояние", НСтр("ru='Состояние';uk='Стан'")));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("Организация", НСтр("ru='Организация';uk='Організація'")));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("Группа", НСтр("ru='Группа ОС';uk='Група ОЗ'"), Ложь));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("ДатаПринятияКУчету", НСтр("ru='Дата принятия к учету';uk='Дата прийняття до обліку'"),,"ДЛФ=DD"));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("СчетУчета", НСтр("ru='Счет учета';uk='Рахунок'"), Ложь));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("ПервоначальнаяСтоимость", НСтр("ru='Первоначальная стоимость';uk='Первинна вартість'"),, "ЧЦ=15; ЧДЦ=2"));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("СправедливаяСтоимость", НСтр("ru='Справедливая стоимость';uk='Справедлива вартість'"), Ложь, "ЧЦ=15; ЧДЦ=2"));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("ЛиквидационнаяСтоимость", НСтр("ru='Ликвидационная стоимость';uk='Ліквідаційна вартість'"), Ложь, "ЧЦ=15; ЧДЦ=2"));
	ОписанияРазделов.Добавить(ОписаниеРаздела);
	
	ОписаниеРаздела = Новый Структура;
	ОписаниеРаздела.Вставить("Синоним", НСтр("ru='Параметры амортизации';uk='Параметри амортизації'"));
	ОписаниеРаздела.Вставить("Реквизиты", Новый Массив);
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("МетодНачисленияАмортизации", НСтр("ru='Метод начисления';uk='Метод нарахування'")));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("СчетАмортизации", НСтр("ru='Счет начисления';uk='Рахунок нарахування'"), Ложь));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("СрокИспользования", НСтр("ru='Срок полезного использования';uk='Строк корисного використання'")));
	ОписаниеРаздела.Реквизиты.Добавить(ОписаниеРеквизита("ОбъемНаработки", НСтр("ru='Предполагаемый объем наработки';uk='Передбачуваний обсяг напрацювання'"),, "ЧЦ=15; ЧДЦ=2"));
	ОписанияРазделов.Добавить(ОписаниеРаздела);
	
	Возврат ОписанияРазделов;
	
КонецФункции

Функция ОписаниеРеквизита(Имя, Синоним, Сравнивать=Истина, Формат="")
	
	Возврат Новый Структура(
		"Имя, Синоним, Сравнивать, Формат",
		Имя,
		Синоним,
		Сравнивать,
		Формат);
	
КонецФункции

Функция ТекстЗапросаСравнения(РеквизитыСравнения)
	
	ТекстЗапроса =
		ТекстЗапросаДанныеБУ()
		+ ТекстЗапросаДанныеМФУ()
		+ "
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Объекты.Ссылка КАК НематериальныйАктив,
		|	Объекты.Наименование КАК Наименование,
		|	ВЫБОР
		|		КОГДА ЛОЖЬ
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьРазличия
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК Объекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеБУ КАК ДанныеБУ
		|		ПО Объекты.Ссылка = ДанныеБУ.НематериальныйАктив
		|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеМФУ КАК ДанныеМФУ
		|		ПО Объекты.Ссылка = ДанныеМФУ.НематериальныйАктив
		|ГДЕ
		|	Объекты.Ссылка В(&Список)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	ДопПоля = "";
	
	ДопУсловия = "";
	
	Для Каждого Раздел Из РеквизитыСравнения Цикл
		
		Для Каждого Реквизит ИЗ Раздел.Реквизиты Цикл
			
			ДопПоля = ДопПоля + СтрЗаменить(
				",
				|	ДанныеБУ.% КАК %БУ,
				|	ДанныеМФУ.% КАК %МФУ",
				"%",
				Реквизит.Имя
			);
			
			Если Реквизит.Сравнивать Тогда
				ДопПоля = ДопПоля + СтрЗаменить(
					",
					|	ВЫБОР КОГДА ЕСТЬNULL(ДанныеБУ.%, НЕОПРЕДЕЛЕНО) = ЕСТЬNULL(ДанныеМФУ.%, НЕОПРЕДЕЛЕНО) ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ КАК %Сравнение",
					"%",
					Реквизит.Имя
				);
				ДопУсловия = ДопУсловия + СтрЗаменить(
					"
					|			ИЛИ ЕСТЬNULL(ДанныеБУ.%, НЕОПРЕДЕЛЕНО) <> ЕСТЬNULL(ДанныеМФУ.%, НЕОПРЕДЕЛЕНО)",
					"%",
					Реквизит.Имя
				);
			Иначе
				ДопПоля = ДопПоля + СтрЗаменить(
					",
					|	ИСТИНА КАК %Сравнение",
					"%",
					Реквизит.Имя
				);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КАК Наименование", "КАК Наименование" + ДопПоля);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КОГДА ЛОЖЬ", "КОГДА ЛОЖЬ" + ДопУсловия);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДанныеБУ()
	
	Возврат
	"ВЫБРАТЬ
	|	ПервоначальныеСведения.НематериальныйАктив КАК Актив,
	|	ПервоначальныеСведения.Организация КАК Организация,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	ПервоначальныеСведения.СпособНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	ПервоначальныеСведения.СрокПолезногоИспользования КАК СрокИспользования,
	|	ПервоначальныеСведения.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемНаработки
	|ПОМЕСТИТЬ ПервоначальныеСведения
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(, НематериальныйАктив В (&Список)) КАК ПервоначальныеСведения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Актив,
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеСостояния.НематериальныйАктив КАК Актив,
	|	ТекущиеСостояния.Состояние
	|ПОМЕСТИТЬ ТекущиеСостояния
	|ИЗ
	|	РегистрСведений.СостоянияНМАОрганизаций.СрезПоследних(
	|			,
	|			(Организация, НематериальныйАктив) В
	|				(ВЫБРАТЬ
	|					ПервоначальныеСведения.Организация,
	|					ПервоначальныеСведения.Актив
	|				ИЗ
	|					ПервоначальныеСведения КАК ПервоначальныеСведения)) КАК ТекущиеСостояния
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТекущиеСостояния.НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостоянияПринятия.НематериальныйАктив КАК Актив,
	|	НАЧАЛОПЕРИОДА(СостоянияПринятия.Период, ДЕНЬ) КАК Дата
	|ПОМЕСТИТЬ ПринятияКУчету
	|ИЗ
	|	РегистрСведений.СостоянияНМАОрганизаций.СрезПоследних(
	|			,
	|			(Организация, НематериальныйАктив, Состояние) В
	|				(ВЫБРАТЬ
	|					ПервоначальныеСведения.Организация,
	|					ПервоначальныеСведения.Актив,
	|					ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК Состояние
	|				ИЗ
	|					ПервоначальныеСведения КАК ПервоначальныеСведения)) КАК СостоянияПринятия
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СостоянияПринятия.НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаУчета.НематериальныйАктив КАК Актив,
	|	СчетаУчета.СчетУчета,
	|	СчетаУчета.СчетНачисленияАмортизации
	|ПОМЕСТИТЬ СчетаУчета
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаНМА.СрезПоследних(
	|			,
	|			(Организация, НематериальныйАктив) В
	|				(ВЫБРАТЬ
	|					ПервоначальныеСведения.Организация,
	|					ПервоначальныеСведения.Актив
	|				ИЗ
	|					ПервоначальныеСведения КАК ПервоначальныеСведения)) КАК СчетаУчета
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетаУчета.НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Активы.Ссылка КАК НематериальныйАктив,
	|	ЕСТЬNULL(ТекущиеСостояния.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) КАК Состояние,
	|	ПервоначальныеСведения.Организация КАК Организация,
	|	ПервоначальныеСведения.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	СчетаУчета.СчетУчета КАК СчетУчета,
	|	СчетаУчета.СчетНачисленияАмортизации КАК СчетАмортизации,
	|	ПринятияКУчету.Дата КАК ДатаПринятияКУчету,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимость КАК СправедливаяСтоимость,
	|	0 КАК ЛиквидационнаяСтоимость,
	|	ПервоначальныеСведения.СрокИспользования КАК СрокИспользования,
	|	ПервоначальныеСведения.ОбъемНаработки КАК ОбъемНаработки,
	|	НЕОПРЕДЕЛЕНО КАК Группа
	|ПОМЕСТИТЬ ДанныеБУ
	|ИЗ
	|	Справочник.НематериальныеАктивы КАК Активы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПервоначальныеСведения КАК ПервоначальныеСведения
	|		ПО Активы.Ссылка = ПервоначальныеСведения.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеСостояния КАК ТекущиеСостояния
	|		ПО Активы.Ссылка = ТекущиеСостояния.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПринятияКУчету КАК ПринятияКУчету
	|		ПО Активы.Ссылка = ПринятияКУчету.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ СчетаУчета КАК СчетаУчета
	|		ПО Активы.Ссылка = СчетаУчета.Актив
	|ГДЕ
	|	Активы.Ссылка В(&Список)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПервоначальныеСведения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТекущиеСостояния
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПринятияКУчету
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СчетаУчета" + ";";
	
КонецФункции

Функция ТекстЗапросаДанныеМФУ()
	
	Возврат
	"ВЫБРАТЬ
	|	ТекущиеСостояния.НематериальныйАктив КАК Актив,
	|	ТекущиеСостояния.Организация,
	|	ТекущиеСостояния.СчетУчета,
	|	ТекущиеСостояния.ЛиквидационнаяСтоимость,
	|	ТекущиеСостояния.ПорядокУчета,
	|	ТекущиеСостояния.МетодНачисленияАмортизации,
	|	ТекущиеСостояния.СчетАмортизации,
	|	ТекущиеСостояния.СрокИспользования,
	|	ТекущиеСостояния.ОбъемНаработки,
	|	ЕСТЬNULL(ТекущиеСостояния.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) КАК Состояние,
	|	ЕСТЬNULL(СостоянияСписания.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаДоПринятияКУчету
	|ПОМЕСТИТЬ ТекущиеСостояния
	|ИЗ
	|	РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(, НематериальныйАктив В (&Список)) КАК ТекущиеСостояния
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(
	|				,
	|				НематериальныйАктив В (&Список)
	|					И Состояние <> ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)) КАК СостоянияСписания
	|		ПО ТекущиеСостояния.НематериальныйАктив = СостоянияСписания.НематериальныйАктив
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Актив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияПринятияКУчету.Период) КАК ДатаПринятияКУчету,
	|	ДвиженияПринятияКУчету.НематериальныйАктив КАК Актив
	|ПОМЕСТИТЬ ПринятияКУчету
	|ИЗ
	|	ТекущиеСостояния КАК ТекущиеСостояния
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет КАК ДвиженияПринятияКУчету
	|		ПО ТекущиеСостояния.Актив = ДвиженияПринятияКУчету.НематериальныйАктив
	|			И ТекущиеСостояния.ДатаДоПринятияКУчету < ДвиженияПринятияКУчету.Период
	|ГДЕ
	|	ДвиженияПринятияКУчету.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияПринятияКУчету.НематериальныйАктив
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Актив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетУчета.Субконто1 КАК Актив,
	|	СчетУчета.СуммаОборотДт КАК Стоимость
	|ПОМЕСТИТЬ ПервоначальнаяСтоимость
	|ИЗ
	|	РегистрБухгалтерии.Международный.ОстаткиИОбороты(
	|			,
	|			,
	|			,
	|			,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ТекущиеСостояния.СчетУчета
	|				ИЗ
	|					ТекущиеСостояния КАК ТекущиеСостояния),
	|			,
	|			(Организация, Субконто1) В
	|				(ВЫБРАТЬ
	|					ТекущиеСостояния.Организация,
	|					ТекущиеСостояния.Актив
	|				ИЗ
	|					ТекущиеСостояния КАК ТекущиеСостояния)) КАК СчетУчета
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Актив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Активы.Ссылка КАК НематериальныйАктив,
	|	ЕСТЬNULL(ТекущиеСостояния.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) КАК Состояние,
	|	ТекущиеСостояния.Организация КАК Организация,
	|	ТекущиеСостояния.СчетУчета КАК СчетУчета,
	|	ТекущиеСостояния.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	ТекущиеСостояния.СчетАмортизации КАК СчетАмортизации,
	|	ПринятияКУчету.ДатаПринятияКУчету КАК ДатаПринятияКУчету,
	|	ПервоначальнаяСтоимость.Стоимость КАК ПервоначальнаяСтоимость,
	|	0 КАК СправедливаяСтоимость,
	|	ТекущиеСостояния.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	ТекущиеСостояния.СрокИспользования КАК СрокИспользования,
	|	ТекущиеСостояния.ОбъемНаработки КАК ОбъемНаработки,
	|	Активы.ГруппаНМАМеждународныйУчет КАК Группа
	|ПОМЕСТИТЬ ДанныеМФУ
	|ИЗ
	|	Справочник.НематериальныеАктивы КАК Активы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеСостояния КАК ТекущиеСостояния
	|		ПО Активы.Ссылка = ТекущиеСостояния.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПринятияКУчету КАК ПринятияКУчету
	|		ПО Активы.Ссылка = ПринятияКУчету.Актив
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость
	|		ПО Активы.Ссылка = ПервоначальнаяСтоимость.Актив
	|ГДЕ
	|	Активы.Ссылка В(&Список)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТекущиеСостояния
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПринятияКУчету
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПервоначальнаяСтоимость"+";";
	
КонецФункции

#КонецОбласти

#КонецЕсли