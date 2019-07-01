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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв3УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.2015 №897 (с изменения по приказу от 08.07.2016 г. № 585)';uk= 'Затверджена наказом Мінфіна від 20.10.2015 №897 (зі змінами згідно Наказу від 08.07.2016 р. № 585)'");
	НоваяФорма.ДатаНачалоДействия = '2016-07-01';
	НоваяФорма.ДатаКонецДействия  = '2017-03-31';
		
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв3УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 08.07.2016 №585 (в редакции приказа Минфина от 28.04.2017 N 467)';uk= 'Затверджена наказом Мінфіна від 08.07.2016 №585 (у редакції наказу Мінфіна від 28.04.2017 N 467)'");
	НоваяФорма.ДатаНачалоДействия = '2017-04-01';
	НоваяФорма.ДатаКонецДействия  = '2018-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1УФ";
	НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена приказом Минфина от 20.10.2015 №897 (в редакции приказа Минфина от 28.04.2017 N 467)';uk= 'Затверджена наказом Мінфіна від 20.10.2015 №897 (у редакції наказу Мінфіна від 28.04.2017 N 467)'");
	НоваяФорма.ДатаНачалоДействия = '2018-01-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
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
	Форма20051001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2005-10-12'		,"448"				,"ФормаОтчета2005Кв4");
	Форма20110401 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-02-28'		,"114"				,"ФормаОтчета2011Кв2");
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2011-09-28'		,"1213"				,"ФормаОтчета2012Кв1");
	Форма20121001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2012-12-05'		,"1281"				,"ФормаОтчета2013Кв1");
	Форма20131001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "", '2013-12-30'		,"872"				,"ФормаОтчета2014Кв1");
	
	Возврат ФормыИФорматы;
	
КонецФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецЕсли