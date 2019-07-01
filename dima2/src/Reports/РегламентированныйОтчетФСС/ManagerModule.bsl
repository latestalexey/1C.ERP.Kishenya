#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Постановлением Правления Фонда социального страхования по временной утрате трудоспособности от  16.11.2011  N 56';uk= 'Затверджена Постановою Правління Фонду соціального страхування по тимчасовій втраті працездатності від  16.11.2011  N 56'");
	НоваяФорма.ДатаНачалоДействия = '20120101';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");          
	                                                                       //дата приказа    //номер приказа     //имя формы
	
	Возврат ФормыИФорматы;
	
КонецФункции

//Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
//			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
//	
//	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
//	НовСтр.Код = СокрЛП(Код);
//	НовСтр.ДатаПриказа = ДатаПриказа;
//	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
//	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
//	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
//	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
//	НовСтр.Описание = СокрЛП(Описание);
//	Возврат НовСтр;
//	
//КонецФункции

#КонецЕсли