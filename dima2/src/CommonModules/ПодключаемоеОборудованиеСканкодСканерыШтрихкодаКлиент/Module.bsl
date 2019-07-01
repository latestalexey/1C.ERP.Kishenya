
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат  = Истина;

	ВыходныеПараметры = Новый Массив();

	// Проверка настроенных параметров.
	БитДанных = Неопределено;
	Порт      = Неопределено;
	Скорость  = Неопределено;
	СтопБит   = Неопределено;
	Префикс   = Неопределено;
	Суффикс   = Неопределено;

	Параметры.Свойство("БитДанных", БитДанных);
	Параметры.Свойство("Порт",      Порт);
	Параметры.Свойство("Скорость",  Скорость);
	Параметры.Свойство("СтопБит",   СтопБит);
	Параметры.Свойство("Префикс",   Префикс);
	Параметры.Свойство("Суффикс",   Суффикс);

	Если БитДанных = Неопределено
	 ИЛИ Порт      = Неопределено
	 ИЛИ Скорость  = Неопределено
	 ИЛИ СтопБит   = Неопределено
	 ИЛИ Суффикс   = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
        |Для корректной работы устройства необходимо задать параметры его работы.
        |Сделать это можно при помощи формы ""Настройка параметров"" модели
        |подключаемого оборудования в форме ""Подключение и настройка оборудования"".'
        |;uk='Не настроєні параметри пристрою.
        |Для коректної роботи пристрою необхідно задати параметри його роботи.
        |Зробити це можна за допомогою форми ""Настройка параметрів"" моделі
        |обладнання для підключення в формі ""Підключення та настройка обладнання"".'"));

		Результат = Ложь;
	КонецЕсли;
	// Конец: Проверка настроенных параметров.

	Если Результат Тогда
		ВыходныеПараметры.Добавить("СканерШтрихкода");
		ВыходныеПараметры.Добавить(Новый Массив());
		ВыходныеПараметры[1].Добавить("ПолученШтрихкод");

		Результат = (ОбъектДрайвера.Подсоединить(ВыходныеПараметры[0]) = 0);
		Если НЕ Результат Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства.
            |Проверьте настройки порта.'
            |;uk='Помилка при підключенні пристрою.
            |Перевірте настройки порту.'"));
		КонецЕсли;

		Если Результат = Истина Тогда
			ОбъектДрайвера.БитДанных  = Параметры.БитДанных;
			ОбъектДрайвера.Порт       = Параметры.Порт;
			ОбъектДрайвера.Скорость   = Параметры.Скорость;
			ОбъектДрайвера.СтопБит    = Параметры.СтопБит;
			ОбъектДрайвера.СтопСимвол = Параметры.Суффикс;

			ОбъектДрайвера.ИмяСобытия = ВыходныеПараметры[1][0];

			Результат = (ОбъектДрайвера.Занять(1) = 0);
			Если Результат Тогда
				ОбъектДрайвера.УстройствоВключено = 1;
				ОбъектДрайвера.ПосылкаДанных      = 1;
				ОбъектДрайвера.ОчиститьВход();
				ОбъектДрайвера.ОчиститьВыход();

				Результат = (ОбъектДрайвера.УстройствоВключено = 1);
				Если НЕ Результат Тогда
					ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

					ВыходныеПараметры.Очистить();
					ВыходныеПараметры.Добавить(999);
					ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства.
                    |Проверьте настройки порта.'
                    |;uk='Помилка при підключенні пристрою.
                    |Перевірте настройки порту.'"));
				КонецЕсли;
			Иначе
				ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

				ВыходныеПараметры.Очистить();
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(НСтр("ru='Не удалось занять устройство.
                |Проверьте настройки порта.'
                |;uk='Не вдалося зайняти пристрій.
                |Перевірте настройки порту.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.УстройствоВключено = 0;
	ОбъектДрайвера.Освободить();
	ОбъектДрайвера.Отсоединить();

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Обработка события от устройства.
	Если Команда = "ОбработатьСобытие" Тогда
		Событие = ВходныеПараметры[0];
		Данные  = ВходныеПараметры[1];

		Результат = ОбработатьСобытие(ОбъектДрайвера, Параметры, ПараметрыПодключения, Событие, Данные, ВыходныеПараметры);

	// Завершение обработки события от устройства.
	ИначеЕсли Команда = "ЗавершитьОбработкуСобытия" Тогда
		РезультатОбработкиСобытия = ВходныеПараметры[0];

		Результат = ЗавершитьОбработкуСобытия(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                      РезультатОбработкиСобытия, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Настройка параметров журналирования драйвера.
	ИначеЕсли Команда = "ПараметрыЖурналирования" Тогда
		Результат = ПараметрыЖурналирования(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.';uk='Команда ""%Команда%"" не підтримується цим драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет обработку внешних событий торгового оборудования.
//
Функция ОбработатьСобытие(ОбъектДрайвера, Параметры, ПараметрыПодключения, Событие, Данные, ВыходныеПараметры)

	Результат = Истина;
	ШК        = СокрЛП(Данные);

	ОбъектДрайвера.ПосылкаДанных = 0;

	Если Параметры.Префикс <> 0 Тогда
		Если Параметры.Префикс = КодСимвола(Лев(ШК, 1)) Тогда
			ШК = Сред(ШК, 2);
		КонецЕсли;
	КонецЕсли;

	ВыходныеПараметры.Добавить("ScanData");
	ВыходныеПараметры.Добавить(Новый Массив());
	ВыходныеПараметры[1].Добавить(ШК);
	ВыходныеПараметры[1].Добавить(Новый Массив());
	ВыходныеПараметры[1][1].Добавить(Данные);
	ВыходныеПараметры[1][1].Добавить(ШК);
	ВыходныеПараметры[1][1].Добавить(0);

	Возврат Результат;

КонецФункции

// Процедура вызывается, когда система готова принять следующее событие от устройства.
Функция ЗавершитьОбработкуСобытия(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                  РезультатОбработкиСобытия, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.ПосылкаДанных = 1;

	Возврат Результат;

КонецФункции

// Осуществляется открытие формы проверки параметров драйвера.
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;

	ОбъектДрайвера.Скорость  = Параметры.Скорость;
	ОбъектДрайвера.БитДанных = Параметры.БитДанных;
	ОбъектДрайвера.СтопБит   = Параметры.СтопБит;

	ОбъектДрайвера.ТестУстройства();

	Возврат Результат;

КонецФункции

// Осуществляется открытие формы настройки параметров журналирования драйвера.
Функция ПараметрыЖурналирования(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.Скорость  = Параметры.Скорость;
	ОбъектДрайвера.БитДанных = Параметры.БитДанных;
	ОбъектДрайвера.СтопБит   = Параметры.СтопБит;

	ОбъектДрайвера.ПараметрыЖурналирования();

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен';uk='Встановлений'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена';uk='Не визначена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти