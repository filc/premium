package hu.filc.naplo.widget_timetable;

import android.content.Intent;
import android.os.Build;
import android.widget.RemoteViewsService;

import androidx.annotation.RequiresApi;

public class WidgetTimetableService extends RemoteViewsService {
    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new WidgetTimetableDataProvider(getApplicationContext(), intent);
    }
}
