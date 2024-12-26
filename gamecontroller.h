#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QVector>
#include <QQmlEngine>

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int rows READ rows WRITE setRows NOTIFY rowsChanged)
    Q_PROPERTY(int columns READ columns WRITE setColumns NOTIFY columnsChanged)
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningChanged)

public:
    explicit GameController(QObject *parent = nullptr);
    static void registerType();

    // Property accessors
    int rows() const { return m_rows; }
    void setRows(int rows);

    int columns() const { return m_columns; }
    void setColumns(int columns);

    bool isRunning() const { return m_timer.isActive(); }

public slots:
    Q_INVOKABLE void startGame();
    Q_INVOKABLE void stopGame();
    Q_INVOKABLE void clearGame();
    Q_INVOKABLE void setCellState(int index, bool alive);
    Q_INVOKABLE void toggleCell(int index);
    Q_INVOKABLE void initializeCells();

signals:
    void gameStarted();
    void gameStopped();
    void gameCleared();
    void cellChanged(int index, bool alive);
    void rowsChanged(int rows);
    void columnsChanged(int columns);
    void isRunningChanged(bool running);
    void initialCellStates();

private slots:
    void updateGame();

private:
    QVector<bool> m_grid;
    QVector<bool> m_nextGrid;
    QTimer m_timer;
    int m_rows;
    int m_columns;

    int countNeighbors(int index) const;
    void initializeGrid();
};

#endif // GAMECONTROLLER_H
