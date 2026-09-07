export const Loader: React.FC = () => {
  return (
    <div className="fixed inset-0 bg-opacity-0 flex items-center justify-center z-50">
      <div className="bg-main_white rounded-full animate-ping p-8 flex flex-col items-center max-w-sm mx-4 flex items-center justify">
        <div className="bg-secondary_gray rounded-full animate-ping w-[1.5rem] h-[1.5rem]"></div>
      </div>
    </div>
  )
}
