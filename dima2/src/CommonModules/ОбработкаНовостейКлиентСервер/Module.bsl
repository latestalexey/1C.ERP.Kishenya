////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработкаХТМЛ

// Функция возвращает текст, обрамленный тегами HTML.
//
// Параметры:
//  Текст        - Строка - сам текст, который надо вывести;
//  Жирный       - Булево;
//  Курсив       - Булево;
//  Подчеркнутый - Булево;
//  ЦветТекста   - Строка (6) - FFFFFF;
//  Гиперссылка  - Строка.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПолучитьФорматированнуюСтроку(
							ЗНАЧ Текст,
							Жирный = Ложь, Курсив = Ложь, Подчеркнутый = Ложь,
							ЦветТекста = Неопределено, Гиперссылка = "") Экспорт

	ТипСтрока = Тип("Строка");

	Если Жирный = Истина Тогда
		Текст = "<B>" + Текст + "</B>";
	КонецЕсли;

	Если Курсив = Истина Тогда
		Текст = "<I>" + Текст + "</I>";
	КонецЕсли;

	Если Подчеркнутый = Истина Тогда
		Текст = "<U>" + Текст + "</U>";
	КонецЕсли;

	Если ТипЗнч(ЦветТекста) = ТипСтрока Тогда
		Текст = "<FONT COLOR=""#%ЦветТекста%"">" + Текст + "</FONT>";
		Текст = СтрЗаменить(Текст, "%ЦветТекста%", ЦветТекста);
	КонецЕсли;

	Если НЕ ПустаяСтрока(Гиперссылка) Тогда
		Текст = "<A HREF=""%Гиперссылка%"">" + Текст + "</A>";
		Текст = СтрЗаменить(Текст, "%Гиперссылка%", Гиперссылка);
	КонецЕсли;

	Возврат Текст;

КонецФункции

// Функция возвращает текст, обрамленный тегами HTML.
//
// Параметры:
//  МассивТекстов - Массив - Массив простых и форматированных текстов.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПолучитьФорматированныйТекст(МассивТекстов) Экспорт

	Текст = "";

	Для каждого ТекущийЭлементМассива Из МассивТекстов Цикл
		Если ТекущийЭлементМассива = Символы.ПС Тогда
			Текст = Текст + "<br/>";
		Иначе
			Текст = Текст + ТекущийЭлементМассива;
		КонецЕсли;
	КонецЦикла;

	Возврат Текст;

КонецФункции

// Функция заменяет специальные символы в коде HTML для правильного отображения новости.
//
// Параметры:
//  Текст - Строка - Код HTML, который необходимо подкорректировать.
//
// Возвращаемое значение:
//   Строка - откорректированный код HTML.
//
Функция ЗаменитьСпециальныеСимволыВHTML(Текст) Экспорт

	лкТекстНовости = Текст;

	// Если разделителем строк вместо символа 13 будет 10, то inline-картинки (<img src="data:image/png;base64,) НЕ будут отображаться.
	// Необходимо заменить символы с кодом 10 на 13.
	лкТекстНовости = СтрЗаменить(лкТекстНовости, Символ(13) + Символ(10), Символ(13));
	лкТекстНовости = СтрЗаменить(лкТекстНовости, Символ(10) + Символ(13), Символ(13));
	лкТекстНовости = СтрЗаменить(лкТекстНовости, Символ(10), Символ(13));
	// Остальные замены.
	// Один символ перевода строки не заменять! Это разрушит inline-base64-картинки.
	лкТекстНовости = СтрЗаменить(лкТекстНовости, Символ(13) + Символ(13), "<#br#/><#br#/>");
	// Пробел с переводом строки заменить на <br/>.
	лкТекстНовости = СтрЗаменить(лкТекстНовости, " " + Символ(13), "<#br#/>");
	// Заменить неявные переводы строк <*>13 на <*> - удалить 13, если он идет сразу после тега.
	// Потому-что это может повлиять на отображение таблиц, которые удобно редактировать с переводами строк.
	лкТекстНовости = СтрЗаменить(лкТекстНовости, ">" + Символ(13), ">");
	// Перевод строки неявно заменить на <br/>.
	лкТекстНовости = СтрЗаменить(лкТекстНовости, "<#br#/>", "<br/>");

	Возврат лкТекстНовости;

КонецФункции

// Функция ищет в тексте новости комментарий вида <!-- {Идентификатор} {Содержимое} --> и возвращает {Содержимое}.
// Разработчикам необходимо учесть факт, что при наличии комментариев "Идентификатор", "Идентификатор1", ... при попытке
//  поиска по "Идентификатор" будут найдены и "Идентификатор" и "Идентификатор1",
//  т.к. не обрабатывается анализ следующего символа после идентификатора - это символ или пробел или перевод строки.
// Эту возможность можно использовать для передачи в тексте новости произвольных параметров, например текст для отображения
//  в другой произвольной обработке (когда не подходят Заголовок, Подзаголовок и ТекстНовости).
//
// Параметры:
//  ДанныеНовости            - Строка или СправочникСсылка.Новости - где искать необходимый комментарий;
//  ИдентификаторКомментария - Строка - идентификатор, по которому необходимо найти данные;
//  ВозвращатьЕслиНеНайдено  - Произвольный - что возвращать, если комментарий не найден.
//
// Возвращаемое значение:
//   Строка или значение параметра функции ВозвращатьЕслиНеНайдено - содержимое комментария.
//
Функция ПолучитьСодержимоеИменованногоКомментария(ДанныеНовости, ИдентификаторКомментария, ВозвращатьЕслиНеНайдено = "") Экспорт

	ТипСтрока  = Тип("Строка");
	ТипНовость = Тип("СправочникСсылка.Новости");

	ТекстПоиска = "";

	Результат = ВозвращатьЕслиНеНайдено;

	Если ТипЗнч(ДанныеНовости) = ТипСтрока Тогда
		ТекстНовости = ДанныеНовости;
	ИначеЕсли ТипЗнч(ДанныеНовости) = ТипНовость Тогда
		ТекстНовости = ДанныеНовости.ТекстНовости;
	КонецЕсли;

	Если НЕ ПустаяСтрока(ТекстНовости) Тогда

		ТегНачала = "<!-- " + ИдентификаторКомментария;
		ТегКонца  = "-->";
		ГдеНачало = СтрНайти(ТекстНовости, ТегНачала);
		Если ГдеНачало > 0 Тогда
			ГдеКонец = СтрНайти(ТекстНовости, ТегКонца, , ГдеНачало);
			Если ГдеКонец > 0 Тогда
				Результат = Сред(ТекстНовости, ГдеНачало + СтрДлина(ТегНачала), ГдеКонец - ГдеНачало - СтрДлина(ТегНачала));
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область КонтекстныеНовости

// Функция создает подменю "Новости" для отображения контекстных новостей.
//
// Параметры:
//  Форма                  - Управляемая форма;
//  ЭлементКоманднаяПанель - Элемент формы, командная панель, в конце которой будет размещено подменю "Новости";
//  ТаблицаНовостей        - таблица значений, в которой должны быть колонки:
//                           Новость, НовостьНаименование, ДатаПубликации, Важность, ЭтоПостояннаяНовость.
//
// Возвращаемое значение:
//   ГруппаФормы - Созданный элемент управления.
//
Функция ДобавитьПодменюПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			ТаблицаНовостей) Экспорт

	ТипМассив = Тип("Массив");

	ЭлементПодменюНовости = Неопределено;

	Если (ТипЗнч(ЭлементКоманднаяПанель) = Тип("ГруппаФормы"))
			ИЛИ (ТипЗнч(ЭлементКоманднаяПанель) = Тип("ПодменюФормы")) Тогда
		// Создать в командной панели подменю "Новости" (если его еще нет).
		ЭлементПодменюНовости = Форма.Элементы.Найти("Новость_ПодменюНовости");
		Если ЭлементПодменюНовости = Неопределено Тогда // Еще подменю не создавали
			ЭлементПодменюНовости = Форма.Элементы.Добавить("Новость_ПодменюНовости", Тип("ГруппаФормы"), ЭлементКоманднаяПанель);
			ЭлементПодменюНовости.Заголовок = НСтр("ru='Новости';uk='Новини'");
			ЭлементПодменюНовости.Вид       = ВидГруппыФормы.Подменю;
			ЭлементПодменюНовости.Картинка  = БиблиотекаКартинок.Новости;
		КонецЕсли;

		Если (ТипЗнч(ЭлементПодменюНовости) = Тип("ГруппаФормы"))
				ИЛИ (ТипЗнч(ЭлементПодменюНовости) = Тип("ПодменюФормы")) Тогда

			Если (ТипЗнч(ТаблицаНовостей) = Тип("ДанныеФормыКоллекция")
					ИЛИ ТипЗнч(ТаблицаНовостей) = Тип("ТаблицаЗначений")
					ИЛИ ТипЗнч(ТаблицаНовостей) = ТипМассив) Тогда // Массив структур

				Если (ТаблицаНовостей.Количество() > 0) Тогда

					// Вначале очистить подменю.
					Для каждого ЭлементПодменю Из ЭлементПодменюНовости.ПодчиненныеЭлементы Цикл
						Форма.Элементы.Удалить(ЭлементПодменю);
					КонецЦикла;

					// Очистить команды формы, начинающиеся с "Команда_Новость_".
					Для каждого ТекущаяКоманда Из Форма.Команды Цикл
						Если Найти(ВРег(ТекущаяКоманда.Имя), ВРег("Команда_Новость_")) = 1 Тогда
							Форма.Команды.Удалить(ТекущаяКоманда.Имя);
						КонецЕсли;
					КонецЦикла;

					// Подменю будет состоять из трех блоков: Постоянные новости, Новости и ссылка на общий список.

					// Добавить несколько первых новостей.
					//  Количество таких новостей = ОбработкаНовостейКлиентСерверПереопределяемый.РазмерПодменюПостоянныхКонтекстныхНовостей().
					// В таблице могут быть повторения (новость для формы элемента и формы списка), поэтому новость добавлять только один раз.
					ПодменюПостоянныхНовостей = Форма.Элементы.Добавить("ПодменюНовости_ПодменюСпискаПостоянныхНовостей", Тип("ГруппаФормы"), ЭлементПодменюНовости);
					ПодменюПостоянныхНовостей.Заголовок = НСтр("ru='Подменю списка постоянных новостей';uk='Підменю списку постійних новин'");
					ПодменюПостоянныхНовостей.Вид       = ВидГруппыФормы.ГруппаКнопок;
					СписокДобавленныхНовостей = Новый СписокЗначений;
					С = 5;
					ОбработкаНовостейКлиентСерверПереопределяемый.ПереопределитьРазмерПодменюПостоянныхКонтекстныхНовостей(С);
					Для каждого ТекущаяНовость Из ТаблицаНовостей Цикл
						Если ТекущаяНовость.ЭтоПостояннаяНовость = Истина Тогда
							НайденнаяСтрока = СписокДобавленныхНовостей.НайтиПоЗначению(ТекущаяНовость.Новость);
							Если НайденнаяСтрока = Неопределено Тогда
								СписокДобавленныхНовостей.Добавить(ТекущаяНовость.Новость);

								НайденнаяНовость = ТекущаяНовость.НомерСтрокиНовости;
								Идентификатор = "Новость_" + НайденнаяНовость;

								НоваяКоманда = Форма.Команды.Добавить("Команда_" + Идентификатор);
								НоваяКоманда.Действие = "Подключаемый_ОбработкаНовости"; // ОбработкаНовости

								ПунктМеню = Форма.Элементы.Добавить(Идентификатор, Тип("КнопкаФормы"), ПодменюПостоянныхНовостей);
								ПунктМеню.ИмяКоманды = НоваяКоманда.Имя;
								// Постоянные новости выводятся без даты.
								ПунктМеню.Заголовок  = ТекущаяНовость.НовостьНаименование;

								С = С - 1;
								Если С <= 0 Тогда
									Прервать;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;

					// Добавить несколько (ОбработкаНовостейКлиентСерверПереопределяемый.ПереопределитьРазмерПодменюКонтекстныхНовостей())
					//  первых новостей.
					// В таблице могут быть повторения (новость для формы элемента и формы списка), поэтому новость добавлять только один раз.
					ПодменюНовостей = Форма.Элементы.Добавить("ПодменюНовости_ПодменюСпискаНовостей", Тип("ГруппаФормы"), ЭлементПодменюНовости);
					ПодменюНовостей.Заголовок = НСтр("ru='Подменю списка новостей';uk='Підменю списку новин'");
					ПодменюНовостей.Вид       = ВидГруппыФормы.ГруппаКнопок;
					СписокДобавленныхНовостей = Новый СписокЗначений;
					С = 10;
					ОбработкаНовостейКлиентСерверПереопределяемый.ПереопределитьРазмерПодменюКонтекстныхНовостей(С);
					Для каждого ТекущаяНовость Из ТаблицаНовостей Цикл
						Если ТекущаяНовость.ЭтоПостояннаяНовость = Ложь Тогда
							НайденнаяСтрока = СписокДобавленныхНовостей.НайтиПоЗначению(ТекущаяНовость.Новость);
							Если НайденнаяСтрока = Неопределено Тогда
								СписокДобавленныхНовостей.Добавить(ТекущаяНовость.Новость);

								НайденнаяНовость = ТекущаяНовость.НомерСтрокиНовости;
								Идентификатор = "Новость_" + НайденнаяНовость;

								НоваяКоманда = Форма.Команды.Добавить("Команда_" + Идентификатор);
								НоваяКоманда.Действие = "Подключаемый_ОбработкаНовости"; // ОбработкаНовости

								ПунктМеню = Форма.Элементы.Добавить(Идентификатор, Тип("КнопкаФормы"), ПодменюНовостей);
								ПунктМеню.ИмяКоманды = НоваяКоманда.Имя;
								// Новости выводятся с датой.
								ПунктМеню.Заголовок  = Формат(ТекущаяНовость.ДатаПубликации, "ДФ=dd.MM.yyyy") + " - " + ТекущаяНовость.НовостьНаименование;
								Если (ТекущаяНовость.Важность = 1) Тогда
									ПунктМеню.Картинка = БиблиотекаКартинок.ВажностьНовостиОченьВажная;
								ИначеЕсли (ТекущаяНовость.Важность = 2) Тогда
									ПунктМеню.Картинка = БиблиотекаКартинок.ВажностьНовостиВажная;
								КонецЕсли;

								С = С - 1;
								Если С <= 0 Тогда
									Прервать;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;

					// Добавить ссылку на форму списка новостей.
					НоваяКоманда = Форма.Команды.Добавить("Команда_Новость_Список");
					НоваяКоманда.Действие    = "Подключаемый_ОбработкаНовости";
					НоваяКоманда.Картинка    = БиблиотекаКартинок.Новости;
					НоваяКоманда.Отображение = ОтображениеКнопки.КартинкаИТекст;

					ПунктМеню = Форма.Элементы.Добавить("Новость_Список", Тип("КнопкаФормы"), ЭлементПодменюНовости);
					ПунктМеню.ИмяКоманды = "Команда_Новость_Список";
					ПунктМеню.Заголовок  = НСтр("ru='Все новости по этой теме';uk='Всі новини по цій темі'");

				КонецЕсли;
			КонецЕсли;

			ОбработкаНовостейКлиентСерверПереопределяемый.ПослеДобавленияПодменюПросмотраСпискаНовостей(
				Форма,
				ЭлементКоманднаяПанель,
				ЭлементПодменюНовости,
				ТаблицаНовостей);

		КонецЕсли;

	КонецЕсли;

	Возврат ЭлементПодменюНовости;

КонецФункции

// Функция создает кнопку "Новости" для отображения списка контекстных новостей.
//
// Параметры:
//  Форма                  - Управляемая форма;
//  ЭлементКоманднаяПанель - Элемент формы, командная панель, в конце которой будет размещена кнопка "Новости";
//  ТаблицаНовостей        - таблица значений, в которой должны быть колонки:
//                           Новость, НовостьНаименование, ДатаПубликации, Важность, ЭтоПостояннаяНовость.
//
// Возвращаемое значение:
//   КнопкаФормы - Созданный элемент управления.
//
Функция ДобавитьКнопкуПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			ТаблицаНовостей) Экспорт

	КомандаНовость = Неопределено;

	Если (ТипЗнч(ЭлементКоманднаяПанель) = Тип("ГруппаФормы")) ИЛИ (ТипЗнч(ЭлементКоманднаяПанель) = Тип("ПодменюФормы")) Тогда

		// Очистить команды формы, начинающиеся с "Команда_Новость_".
		Для каждого ТекущаяКоманда Из Форма.Команды Цикл
			Если Найти(ВРег(ТекущаяКоманда.Имя), ВРег("Команда_Новость_")) = 1 Тогда
				Форма.Команды.Удалить(ТекущаяКоманда.Имя);
			КонецЕсли;
		КонецЦикла;

		КомандаНовость = Форма.Команды.Добавить("Команда_Новость_Список");
		КомандаНовость.Действие    = "Подключаемый_ОбработкаНовости"; // ОбработкаНовости
		КомандаНовость.Картинка    = БиблиотекаКартинок.Новости;
		КомандаНовость.Отображение = ОтображениеКнопки.КартинкаИТекст;
		КомандаНовость.Подсказка   = НСтр("ru='Нажмите для открытия списка контекстных новостей';uk='Натисніть для відкриття списку контекстних новин'");

		КнопкаНовостей = Форма.Элементы.Добавить("КнопкаНовостей", Тип("КнопкаФормы"), ЭлементКоманднаяПанель);
		КнопкаНовостей.Заголовок             = НСтр("ru='Новости';uk='Новини'");
		КнопкаНовостей.Вид                   = ВидКнопкиФормы.КнопкаКоманднойПанели;
		КнопкаНовостей.ИмяКоманды            = КомандаНовость.Имя;
		КнопкаНовостей.ТолькоВоВсехДействиях = Ложь;

		ОбработкаНовостейКлиентСерверПереопределяемый.ПослеДобавленияКнопкиПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			КнопкаНовостей,
			ТаблицаНовостей);

	КонецЕсли;

	Возврат КомандаНовость;

КонецФункции

#КонецОбласти

#Область ОбработкаСтрок

// Функция приводит к правильному формату версии переданную строку:
//  - приводит к формату 99.99.999.9999;
//  - заменяет пробелы на нули;
//  - если пробел в конце, то сдвигает число направо (" 17 ", "  17", "17  " -> "0017").
//
// Параметры:
//  Версия  - Строка - Строка, которую необходимо преобразовать.
//
// Возвращаемое значение:
//   Строка - версия правильного вида, формата 99.99.999.9999.
//
Функция ПривестиСтрокуКПравильномуФорматуВерсии(Версия) Экспорт

	Число1 = СокрЛП(Сред(Версия, 1, 2));
	Число2 = СокрЛП(Сред(Версия, 4, 2));
	Число3 = СокрЛП(Сред(Версия, 7, 3));
	Число4 = СокрЛП(Сред(Версия, 11, 4));

	Попытка
		Число1 = ?(ПустаяСтрока(Число1), 0, Число(Число1));
	Исключение
		Число1 = 0;
	КонецПопытки;

	Попытка
		Число2 = ?(ПустаяСтрока(Число2), 0, Число(Число2));
	Исключение
		Число2 = 0;
	КонецПопытки;

	Попытка
		Число3 = ?(ПустаяСтрока(Число3), 0, Число(Число3));
	Исключение
		Число3 = 0;
	КонецПопытки;

	Попытка
		Число4 = ?(ПустаяСтрока(Число4), 0, Число(Число4));
	Исключение
		Число4 = 0;
	КонецПопытки;

	НоваяВерсия =
		Формат(Число1, "ЧЦ=2; ЧН=00; ЧВН=; ЧГ=0") + "." +
		Формат(Число2, "ЧЦ=2; ЧН=00; ЧВН=; ЧГ=0") + "." +
		Формат(Число3, "ЧЦ=3; ЧН=000; ЧВН=; ЧГ=0") + "." +
		Формат(Число4, "ЧЦ=4; ЧН=0000; ЧВН=; ЧГ=0");

	Возврат НоваяВерсия;

КонецФункции

// Функция из версии формата 99.99.999.9999 удаляет лидирующие нули, чтобы 08.02.019.0080 выглядело как 8.2.19.80.
//
// Параметры:
//  Версия - Строка - строка формата 99.99.999.9999, в которой необходимо удалить лидирующие нули, а также заменить:
//                    А.00.000.0000 = А,
//                    А.Б.000.0000 = А.Б,
//                    А.Б.В.0000 = А.Б.В,
//                    А.99.999.9999 = А.*,
//                    А.Б.999.9999 = А.Б.*,
//                    А.Б.В.9999 = А.Б.В.*.
//
// Возвращаемое значение:
//   Строка - удобочитаемое представление версии.
//
Функция ПолучитьУдобочитаемоеПредставлениеВерсии(Версия) Экспорт

	Результат = "";

	Версии = СтрЗаменить(Версия, ".", Символы.ПС);
	Если СтрЧислоСтрок(Версии) <> 4 Тогда
		Результат = Версия; // оставить как есть
	Иначе
		Версия1 = СтрПолучитьСтроку(Версии, 1);
		Версия2 = СтрПолучитьСтроку(Версии, 2);
		Версия3 = СтрПолучитьСтроку(Версии, 3);
		Версия4 = СтрПолучитьСтроку(Версии, 4);
		Если (Версия2 = "00") И (Версия3 = "000") И (Версия4 = "0000") Тогда
			// А.00.000.0000 = А
			Результат =
				Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
		ИначеЕсли (СтрПолучитьСтроку(Версии, 3) = "000") И (СтрПолучитьСтроку(Версии, 4) = "0000") Тогда
			// А.Б.000.0000 = А.Б
			Результат =
				Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
		ИначеЕсли (СтрПолучитьСтроку(Версии, 4) = "0000") Тогда
			// А.Б.В.0000 = А.Б.В
			Результат =
				Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия3), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
		ИначеЕсли (Версия2 = "99") И (Версия3 = "999") И (Версия4 = "9999") Тогда
			// А.99.999.9999 = А.*
			Результат =
				Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ ".*";
		ИначеЕсли (Версия3 = "999") И (Версия4 = "9999") Тогда
			// А.Б.999.9999 = А.Б.*
			Результат =
				Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ ".*";
		ИначеЕсли (Версия4 = "9999") Тогда
			// А.Б.В.9999 = А.Б.В.*
			Результат =
				Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия3), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ ".*";
		Иначе
			Результат = Формат(Число(Версия1), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия2), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия3), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0")
				+ "." + Формат(Число(Версия4), "ЧЦ=4; ЧДЦ=0; ЧН=0; ЧГ=0");
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция генерирует удобочитаемое представление интервала версий.
//
// Параметры:
//  Версия - Строка - строка формата 99.99.999.9999, в которй необходимо удалить лидирующие нули.
//
// Возвращаемое значение:
//   Строка - удобочитаемое представление версии.
//
Функция ПолучитьУдобочитаемоеПредставлениеИнтервалаВерсий(ВерсияОТ, ВерсияДО) Экспорт

	Результат = "";

	Если (ВерсияОТ = "00.00.000.0000") И (ВерсияДО = "99.99.999.9999") Тогда
		Результат = НСтр("ru='Любая версия';uk='Будь-яка версія'");
	ИначеЕсли (ВерсияОТ <> "00.00.000.0000") И (ВерсияДО <> "99.99.999.9999") Тогда
		Если ВерсияОТ = ВерсияДО Тогда // Точная версия
			Результат = ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияОТ);
		Иначе // Интервал версий
			Результат = НСтр("ru='Интервал %ВерсияОТ%...%ВерсияДО%';uk='Інтервал %ВерсияОТ%...%ВерсияДО%'");
			Результат = СтрЗаменить(Результат, "%ВерсияОТ%", ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияОТ));
			Результат = СтрЗаменить(Результат, "%ВерсияДО%", ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияДО));
		КонецЕсли;
	ИначеЕсли (ВерсияОТ <> "00.00.000.0000") И (ВерсияДО = "99.99.999.9999") Тогда
		Результат = НСтр("ru='От %ВерсияОТ% и выше';uk='Від %ВерсияОТ% і вище'"); // От версии и выше
		Результат = СтрЗаменить(Результат, "%ВерсияОТ%", ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияОТ));
	ИначеЕсли (ВерсияОТ = "00.00.000.0000") И (ВерсияДО <> "99.99.999.9999") Тогда
		Результат = НСтр("ru='До версии %ВерсияДО% включительно';uk='До версії %ВерсияДО% включно'"); // До версии включительно
		Результат = СтрЗаменить(Результат, "%ВерсияДО%", ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияДО));
	Иначе // Воспринимать как Интервал версий
		Результат = НСтр("ru='Интервал %ВерсияОТ%...%ВерсияДО%.';uk='Інтервал %ВерсияОТ%...%ВерсияДО%.'");
		Результат = СтрЗаменить(Результат, "%ВерсияОТ%", ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияОТ));
		Результат = СтрЗаменить(Результат, "%ВерсияДО%", ПолучитьУдобочитаемоеПредставлениеВерсии(ВерсияДО));
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция ищет в списке значений по представлению.
//
// Параметры:
//  Список        - СписокЗначений - Список значений параметров;
//  Представление - Строка - Представление, которое необходимо найти.
//
// Возвращаемое значение:
//   ЭлементСпискаЗначений - значение элемента списка значений, или Неопределено, если представление не найдено.
//
Функция НайтиПоПредставлению(Список, Представление) Экспорт

	ТипСписокЗначений = Тип("СписокЗначений");

	Результат = Неопределено;

	Если ТипЗнч(Список) = ТипСписокЗначений Тогда
		Для каждого ТекущийЭлементСписка Из Список Цикл
			Если ВРег(ТекущийЭлементСписка.Представление) = ВРег(Представление) Тогда
				Результат = ТекущийЭлементСписка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает строковое представление для произвольного значения.
//
// Параметры:
//  лкЗначение   - Произвольный - значение произвольного типа, которое надо вывести в виде строки;
//  Разделитель1 - Строка - разделитель значений 1 (например, разделяет элементы массива или ключ и значение структуры или соответствия);
//  Разделитель2 - Строка - разделитель значений 2 (например, разделяет элементы структуры или соответствия);
//  Уровень      - Число  - Значение уровня, влияет на отступ.
//
// Возвращаемое значение:
//   Строка - строковое представление.
//
Функция ПолучитьСтроковоеПредставление(лкЗначение, Разделитель1 = "", Разделитель2 = "", Знач Уровень = 0) Экспорт

	Результат = "";

	ТипЧисло                     = Тип("Число");
	ТипСтрока                    = Тип("Строка");
	ТипДата                      = Тип("Дата");
	ТипБулево                    = Тип("Булево");
	ТипСписокЗначений            = Тип("СписокЗначений");
	ТипМассив                    = Тип("Массив");
	ТипФиксированныйМассив       = Тип("ФиксированныйМассив");
	ТипСтруктура                 = Тип("Структура");
	ТипФиксированнаяСтруктура    = Тип("ФиксированнаяСтруктура");
	ТипСоответствие              = Тип("Соответствие");
	ТипФиксированноеСоответствие = Тип("ФиксированноеСоответствие");

	Если ТипЗнч(Уровень) <> ТипЧисло
			ИЛИ Уровень < 0 Тогда
		Уровень = 0;
	КонецЕсли;

	Если ТипЗнч(лкЗначение) = ТипСтрока Тогда
		Результат = ПовторитьСимволы("  ", Уровень) + лкЗначение;
	ИначеЕсли ТипЗнч(лкЗначение) = ТипДата Тогда
		Результат = ПовторитьСимволы("  ", Уровень) + Формат(лкЗначение, "ДФ='dd.MM.yyyy HH:mm:ss'");
	ИначеЕсли ТипЗнч(лкЗначение) = ТипЧисло Тогда
		Результат = ПовторитьСимволы("  ", Уровень) + Формат(лкЗначение, "ЧЦ=15; ЧДЦ=4; ЧРД=,; ЧРГ=' '; ЧН=0,0000; ЧГ=3,0");
	ИначеЕсли ТипЗнч(лкЗначение) = ТипБулево Тогда
		Результат = ПовторитьСимволы("  ", Уровень) + Формат(лкЗначение, "БЛ=Ложь; БИ=Истина");
	ИначеЕсли ТипЗнч(лкЗначение) = ТипСписокЗначений Тогда
		С = 1;
		Для Каждого ТекущееЗначение Из лкЗначение Цикл
			Если С = лкЗначение.Количество() Тогда
				Результат = Результат + ПовторитьСимволы("  ", Уровень) + СокрЛП(ТекущееЗначение.Значение);
			Иначе
				Результат = Результат + ПовторитьСимволы("  ", Уровень) + СокрЛП(ТекущееЗначение.Значение) + Разделитель1;
			КонецЕсли;
			С = С + 1;
		КонецЦикла;
	ИначеЕсли (ТипЗнч(лкЗначение) = ТипМассив) ИЛИ (ТипЗнч(лкЗначение) = ТипФиксированныйМассив) Тогда
		С = 1;
		Для Каждого ТекущееЗначение Из лкЗначение Цикл
			Если С = лкЗначение.Количество() Тогда
				Результат = Результат + ПовторитьСимволы("  ", Уровень) + СокрЛП(ТекущееЗначение);
			Иначе
				Результат = Результат + ПовторитьСимволы("  ", Уровень) + СокрЛП(ТекущееЗначение) + Разделитель1;
			КонецЕсли;
			С = С + 1;
		КонецЦикла;
	ИначеЕсли (ТипЗнч(лкЗначение) = ТипСтруктура) ИЛИ (ТипЗнч(лкЗначение) = ТипФиксированнаяСтруктура) Тогда
		Для Каждого КлючЗначение Из лкЗначение Цикл
			Результат =
				Результат
				+ ПовторитьСимволы("  ", Уровень)
				+ КлючЗначение.Ключ
				+ Разделитель1
				+ ПолучитьСтроковоеПредставление(КлючЗначение.Значение, Разделитель1, Разделитель2, Уровень + 1)
				+ Разделитель2;
		КонецЦикла;
	ИначеЕсли (ТипЗнч(лкЗначение) = ТипСоответствие) ИЛИ (ТипЗнч(лкЗначение) = ТипФиксированноеСоответствие) Тогда
		Для Каждого КлючЗначение Из лкЗначение Цикл
			Результат =
				Результат
				+ ПовторитьСимволы("  ", Уровень)
				+ ПолучитьСтроковоеПредставление(КлючЗначение.Ключ, Разделитель1, Разделитель2, Уровень + 1)
				+ Разделитель1
				+ ПолучитьСтроковоеПредставление(КлючЗначение.Значение, Разделитель1, Разделитель2, Уровень + 1)
				+ Разделитель2;
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция повторяет символы заданное количество раз.
//
// Параметры:
//  СимволыДляПовтора  - Строка - Символы, которые необходимо повторить;
//  КоличествоПовторов - Число - количество повторов.
//
// Возвращаемое значение:
//   Строка - результирующая строка.
//
Функция ПовторитьСимволы(СимволыДляПовтора = "  ", КоличествоПовторов = 0) Экспорт

	Результат = "";

	ТипСтрока = Тип("Строка");
	ТипЧисло  = Тип("Число");

	Если ТипЗнч(СимволыДляПовтора) = ТипСтрока
			И ТипЗнч(КоличествоПовторов) = ТипЧисло
			И КоличествоПовторов > 0 Тогда
		Для С=1 По КоличествоПовторов Цикл
			Результат = Результат + СимволыДляПовтора;
		КонецЦикла;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает количество новостей прописью.
//
// Параметры:
//  КоличествоНовостей - Число;
//
// Возвращаемое значение:
//  Строка.
//
Функция КоличествоНовостейПрописью(КоличествоНовостей) Экспорт

	Результат = 
		НРег(
			ЧислоПрописью(
				КоличествоНовостей,
				"НП=Истина; НД=Ложь;",
				НСтр("ru='новость,новости,новостей,ж,,,,,0';uk='новина,новини,новин,ж,,,,,0'")));

	Возврат Результат;

КонецФункции

// Функция возвращает строку доступных для задания кода символов - английские буквы, цифры, минус, подчеркивание и т.п.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПолучитьРазрешенныеДляИдентификацииСимволы() Экспорт

	Результат = "_-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	Возврат Результат;

КонецФункции

// Функция возвращает строку цифр.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПолучитьВсеЦифры() Экспорт

	Результат = "0123456789";
	Возврат Результат;

КонецФункции

// Функция проверяет, все ли символы идентификатора соответствуют разрешенным.
//
// Параметры:
//  СтрокаДляПроверки  - Строка - идентификатор для проверки;
//  РазрешенныеСимволы - Строка - строка со списком разрешенных символов.
//
// Возвращаемое значение:
//  Список значений - если пустой, значит ошибок нет, в противном случае, в него будут возвращены все неправильные символы.
//
Функция ПроверитьИдентификаторНаЗапрещенныеСимволы(СтрокаДляПроверки, РазрешенныеСимволы) Экспорт

	СписокЗапрещенныхСимволов = Новый СписокЗначений;

	лкСтрокаДляПроверки = СокрЛП(СтрокаДляПроверки);

	Для С=1 По СтрДлина(лкСтрокаДляПроверки) Цикл
		Символ = Сред(лкСтрокаДляПроверки, С, 1);
		Если (Найти(РазрешенныеСимволы, Символ) = 0) Тогда
			// Найден неразрешенный символ, добавить в список.
			Если СписокЗапрещенныхСимволов.НайтиПоЗначению(Символ) = Неопределено Тогда
				СписокЗапрещенныхСимволов.Добавить(Символ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат СписокЗапрещенныхСимволов;

КонецФункции

#КонецОбласти

#Область БуферОбмена

// Возвращает пустую структуру для заполнения данными буфера обмена.
// Для использования в качестве буфера обмена Массив Структур, в отличие от ТаблицыЗначений,
//  может существовать и на клиенте и на сервере.
//
// Параметры:
//  КлючОбъекта  - Строка - Ключ, с которым данные будут сохранены в ХранилищеНастроек.БуферОбмена.
//
// Возвращаемое значение:
//   Структура - пустая Структура со всеми необходимыми полями.
//
Функция ПолучитьСтруктуруПолейБуфераОбмена(КлючОбъекта) Экспорт

	Результат = Новый Структура;

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") Тогда
		Результат = Новый Структура("КатегорияНовостей, КатегорияНовостейКод, УсловиеОтбора, ЗначениеКатегорииНовостей, ЗначениеКатегорииНовостейКод, Автор");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий") Тогда
		Результат = Новый Структура("КатегорияНовостей, КатегорияНовостейКод, Продукт, ПродуктКод, ВерсияОТ, ВерсияДО, ПредставлениеИнтервалаВерсий, Автор");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным") Тогда
		Результат = Новый Структура("Метаданные, Форма, Событие, ПоказыватьВФормеОбъекта, Важность, ДатаСбросаВажности, ДатаСбросаВажностиМестная, ЭтоПостояннаяНовость");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные") Тогда
		Результат = Новый Структура("УИН, Заголовок, ИнтернетСсылка, ПорядокСортировки, ДанныеСтрока64, ДанныеРазмер");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия") Тогда
		Результат = Новый Структура("УИНДействия, Действие, ПараметрыДействий");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПараметрыДействий") Тогда
		Результат = Новый Структура("Параметр, ЗначениеПараметра");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители") Тогда
		Результат = Новый Структура("Продукт, ВерсияПродукта, ВерсияОТ, ВерсияДО, ВерсииСинхронизированы, ПредставлениеИнтервалаВерсий");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей") Тогда
		Результат = Новый Структура("КаналРаспространенияНовостей, ВерсияОТ, ВерсияДО, ПредставлениеИнтервалаВерсий");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		Результат = Новый Структура("ТематическаяПодборка, Чтение, Изменение, Публикация, ОтменаПубликации");
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПолучениеНастроекКонфигурации

// Возвращает адрес команды открытия списка новостей.
// Если подсистема ИПП выключена из командного интерфейса, то вернуть
//   e1cib/command/Справочник.Новости.Команда.КомандаСписокНовостей.
// Если подсистема ИнтернетПоддержкаПользователей включена в командный интерфейс (хотя может быть и не видна), то вернуть
//   e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокНовостей.
// Так как наша система должна быть выключена из командного интерфейса, то всегда возвращать первый вариант.
// В случае внедрения в демобазу (когда подсистема включена в командный интерфейс), использовать:
//   Результат = "e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокНовостей";
//
// Параметры:
//  Нет.
//
// Возвращаемое значение
//  Строка - актуальный адрес команды открытия формы списка новостей.
//
Функция ПолучитьНавигационнуюСсылкуСпискаНовостей() Экспорт

	Результат = "e1cib/command/Справочник.Новости.Команда.КомандаСписокНовостей"; // Если подсистема НЕ внедрена в командный интерфейс

	Возврат Результат;

КонецФункции

#КонецОбласти

